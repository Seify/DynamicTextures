//
//  ResourceManager.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 23.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "ResourceManager.h"
#import "InterfaceConstants.h"
#import "DynamicTexturesAppDelegate.h"
#import "models.h"

@interface ResourceManager()
{
    NSMutableDictionary *texturesDictionary;
    NSMutableDictionary *texturesCompressedDictionary;
    NSMutableDictionary *programsDictionary;
    GLuint textures[MAX_CACHE_SIZE];
    int counterOfLoadingTextures;
}
@property NSMutableDictionary *texturesDictionary;
@property (readonly) NSMutableDictionary *texturesCompressedDictionary;
@property (readonly) NSMutableDictionary *programsDictionary;

- (GLuint)loadProgram:(programID)programid;
- (void)bindAttributeLocations:(programID)programid program:(GLuint)program;
- (void)getUniformLocations:(programID)programid program:(GLuint)program;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
@end

@implementation ResourceManager

- (NSMutableDictionary *)texturesDictionary{
       
    if (!texturesDictionary) {
        texturesDictionary = [NSMutableDictionary dictionary];
        [texturesDictionary retain];
    }
    return texturesDictionary;
}

- (void) setTexturesDictionary:(NSMutableDictionary *)newTexturesDictionary
{
    if (texturesDictionary != newTexturesDictionary){
        [texturesDictionary release];
        texturesDictionary = newTexturesDictionary;
        [texturesDictionary retain];
    }
}

- (NSMutableDictionary *)texturesCompressedDictionary{
    
    if (!texturesCompressedDictionary) {
        texturesCompressedDictionary = [NSMutableDictionary dictionary];
        [texturesCompressedDictionary retain];
    }
    return texturesCompressedDictionary;
}

- (NSMutableDictionary *)programsDictionary{
    if (!programsDictionary) {
        programsDictionary = [NSMutableDictionary dictionary];
        [programsDictionary retain];
    }
    return programsDictionary;
}

#pragma mark - Models

- (vertexDataTextured *) getModel:(modelID)modelid{
    
    vertexDataTextured *retValue;
    
    switch (modelid) {
        case MODEL_SHEET_LEFT:
            retValue = (vertexDataTextured *)&sheetOfPaperLeft;
            break;

        case MODEL_SHEET_RIGHT:
            retValue = (vertexDataTextured *)&sheetOfPaperRight;
            break;
            
        case MODEL_SHEET_COLORED:
            retValue = (vertexDataTextured *)&sheetOfPaperCentered;
            break;
            
        default:
            NSLog(@"%@ : %@ WARNING!!! unexpected modelID: %d", self, NSStringFromSelector(_cmd), modelid);
            retValue = nil;
            break;
    }

    return retValue;
};

- (GLuint) getVertexesCountForModel:(modelID)modelid
{
    GLuint retValue;
    
    
    switch (modelid) {
        case MODEL_SHEET_LEFT:
        case MODEL_SHEET_RIGHT:{
            return 6;
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARNING!!! unexpected modelID: %d", self, NSStringFromSelector(_cmd), modelid);
        }
            break;
    }
    
    return retValue;
};

#pragma mark - Textures

- (GLuint) getCompressedTexture:(textureID)textureid 
                     Parameters:(NSDictionary *)parameters
{
    NSString *key;
    NSString *filePath;
    
    switch (textureid) {
        case TEXTURE_BLACK_AND_WHITE_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];
            key = [NSString stringWithFormat:@"textureID %d booknumber %d pagenumber %d", textureid, booknumber, pagenumber];
            filePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.pvrtc", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                NSLog(@"%@ : %@ Warning! Failed %@ does NOT EXISTS", self, NSStringFromSelector(_cmd), filePath);
            }
                        
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARINING!!! undexpected textureid: %d", self, NSStringFromSelector(_cmd), textureid);
            break;
        }
            
    }
    
    
    Texture *texture = [self.texturesCompressedDictionary objectForKey:key];
    
    if (!texture)
    {
        
        GLuint texNum;
        glGenTextures(1, &texNum);
        
        texture = [[Texture alloc] init];
        texture.state = TEXTURE_STATE_UNLOADED;
        texture.texturePointer = texNum;
        
        glBindTexture(GL_TEXTURE_2D, texture.texturePointer);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        
        NSData *texData = [[NSData alloc] initWithContentsOfFile:filePath];
        
        glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 1024, 1024, 0, [texData length], [texData bytes]);
        
        [texData release];

        
        
        [self.texturesCompressedDictionary setObject:texture forKey:key];
        
    }
    
    return texture.texturePointer;
    
//    PVRTexture *pvrtcTexture = [self.texturesCompressedDictionary objectForKey:key];
//    
//    if (!pvrtcTexture)
//    {
//        pvrtcTexture = [[PVRTexture alloc] initWithContentsOfFile:filePath];
//    }
//        
//    if (pvrtcTexture){
//        [self.texturesCompressedDictionary setObject:pvrtcTexture forKey:key];
//    } 
//    else
//    {
//        
//        NSLog(@"%@ : %@ Warning! Failed to create pvrtcTexture from file %@", self, NSStringFromSelector(_cmd), filePath);
//
//        return 0;
//    }
//    
//    return pvrtcTexture.name;
}

- (NSString *)pathForTextureID:(textureID)textureid Parameters:(NSDictionary *)parameters
{
    NSString *filePath;
    int downscaleFactor = 1;
    
    switch (textureid) {
            
        case TEXTURE_COLORING_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int savingsVersionNumber = [[parameters objectForKey:@"versionnumber"] intValue];
                        
            filePath = [self filePathForColoredPictureOfBookNumber:booknumber VersionNumber:savingsVersionNumber];
                        
            break;
        }
            
        case BOOK_COVER_TEXTURE:
        {
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            
            filePath = [NSString stringWithFormat:@"%@/books/book%d/cover/cover.png", [[NSBundle mainBundle] resourcePath], booknumber];
            
            NSLog(@"%@ : %@ filePath = %@", self, NSStringFromSelector(_cmd), filePath);
            
            break;
        }
            
            
        case TEXTURE_BLACK_AND_WHITE_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];

            filePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
            
            break;
        }
            
        case CRAYON_RUNNING_LIGHT_1_TEXTURE:{
            
            filePath = [[NSBundle mainBundle] pathForResource:@"running_light1" ofType:@"png"];
            
            break;
        }
            
        case CRAYON_RUNNING_LIGHT_2_TEXTURE:{
            
            filePath = [[NSBundle mainBundle] pathForResource:@"running_light2" ofType:@"png"];
            
            break;
        }
            
        case CRAYON_HIGHLIGHT_TEXTURE:{
            
            filePath = [[NSBundle mainBundle] pathForResource:@"highlight" ofType:@"png"];
            
            break;
        }    
            
        case CRAYON_RUNNING_SHADOW_TEXTURE:{
            
            filePath = [[NSBundle mainBundle] pathForResource:@"running_shadow" ofType:@"png"];
            
            break;
        }
            
        case TEXTURE_BACKGROUND:{

            filePath = [[NSBundle mainBundle] pathForResource:@"woodenBGWithPictures" ofType:@"jpg"];
            
            break;
        }
            
        case STAR_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"];
            
            break;     
        }
            
        case CIRCLE_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"CircleHaloInv" ofType:@"png"];
            
            break;
        }
            
        case TEXTURE_PAPER:{
            filePath = [[NSBundle mainBundle] pathForResource:@"paperTexture1" ofType:@"png"];
            
            break;
        }
            
        case TEXTURE_DRAWING_TOOLS_BOX:{
            filePath = [[NSBundle mainBundle] pathForResource:@"DrawingToolsBox" ofType:@"png"];
            
            break;
        }
            
        case BUTTON_TEXTURE:{
            
            int buttonType = [[parameters objectForKey:@"buttontype"] intValue];
            int paintingMode = [[parameters objectForKey:@"paintingmode"] intValue];  
            
            switch (buttonType) {
                    //                    case BUTTON_UNDO:{
                    //                        image = [UIImage imageNamed:@"pin.png"];
                    //                        break;
                    //                    }
                    
                case BUTTON_CLEAR_PAINTING:{
                    filePath = [[NSBundle mainBundle] pathForResource:@"RestartButton" ofType:@"png"];
                    break;
                }
                    
                case BUTTON_PREVIOUS:{
                    filePath = [[NSBundle mainBundle] pathForResource:@"LeftButton" ofType:@"png"];
                    break;                        
                }
                    
                case BUTTON_NEXT:{
                    filePath = [[NSBundle mainBundle] pathForResource:@"RightButton" ofType:@"png"];
                    break;                        
                }
                    
                case BUTTON_CHANGE_PAINTING_MODE:{
                    
                    switch (paintingMode) {
                        case paintModeSimple:{
                            
                            filePath = [[NSBundle mainBundle] pathForResource:@"PaintingModeFilling" ofType:@"png"];
                            break;
                        }
                            
                        case paintModeMedium:{
                            filePath = [[NSBundle mainBundle] pathForResource:@"PaintingModePainting" ofType:@"png"];
                            break;
                        }
                            
                        default: {
                            NSLog(@"%@ : %@ unexpected paint mode: %d", self, NSStringFromSelector(_cmd), paintingMode);
                            break;
                        }
                    }
                    
                    break;                        
                }
                case BUTTON_CUSTOM_COLOR:{   
                    filePath = [[NSBundle mainBundle] pathForResource:@"SelectDrawingToolButton" ofType:@"png"];
                    break;                        
                }
                    
                case BUTTON_BACK_TO_GALLERY:{
                    filePath = [[NSBundle mainBundle] pathForResource:@"GalleryButton" ofType:@"png"];
                    break; 
                }
                    
                case BUTTON_SHOW_SAMPLE:{
                    filePath = [[NSBundle mainBundle] pathForResource:@"ExampleButtonBg" ofType:@"png"];
                    break;                     
                }                    
                    
                default:{
                    NSLog(@"%@ : %@ WARINING!!! unexpected button type: %d", self, NSStringFromSelector(_cmd), buttonType);
                    break;
                }
            }
            
            
            break;
        }
            
        case ERASER_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"Eraser" ofType:@"png"];
            downscaleFactor = 1;
            
            break; 
        }
            
        case ERASER_SELECTED_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"EraserSelected" ofType:@"png"];
            downscaleFactor = 1;
            
            break; 
        }
            
        case ERASER_UNSELECTED_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"EraserUnselected" ofType:@"png"];
            downscaleFactor = 1;
            
            break; 
        }
            
        case UNDO_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"UndoButtonBg" ofType:@"png"];
            
            break; 
        }
            
        case SLIDER_BACKGROUND_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"SliderBack" ofType:@"png"];
            
            break; 
        }
            
        case TOOL_COLOR_AND_SIZE_INDICATOR_TEXTURE:
        {
            filePath = [[NSBundle mainBundle] pathForResource:@"BrushSizeIndicatorLarge" ofType:@"png"];
            
            break;
        }
            
        case BRUSH_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"particleWithPaperTexture1" ofType:@"png"];
            break;
        }
            
        case UNDO_LIGHT_ON_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"UndoButtonLightOn" ofType:@"png"];
            break;
        }
            
        case UNDO_LIGHT_OFF_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"UndoButtonLightOff" ofType:@"png"];
            break;
        }
            
        case GALLERY_BOOK_COVER_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"GalleryBookCover" ofType:@"png"];
            break;
        }
            
        case POLKA_TEXTURE:
        {
            filePath = [[NSBundle mainBundle] pathForResource:@"Polka" ofType:@"png"];
            break;
        }
         
        case RAINBOW_TOOL_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"RainbowTool" ofType:@"png"];
            break;
        }
            
        case RAINBOW_TOOL_INDICATOR_TEXTURE:{
            filePath = [[NSBundle mainBundle] pathForResource:@"RainbowToolIndicator" ofType:@"png"];
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARINING!!! undexpected textureid: %d", self, NSStringFromSelector(_cmd), textureid);
            break;
        }
    }

    return filePath;
}

- (GLuint) getTexture:(textureID)textureid 
           Parameters:(NSDictionary *)parameters
            InContext:(EAGLContext *)currentContext 
           ShouldLoad:(BOOL)shouldLoad
                Async:(BOOL)async{
    
    GLuint retValue;
    
    NSString *key;
//    NSString *filePath;
    int downscaleFactor = 1;
    
    switch (textureid) {
            
        case BOOK_COVER_TEXTURE:
        {
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            
            key = [NSString stringWithFormat:@"textureID %d booknumber %d", textureid, booknumber];
            
            break;
        }
                        
        case TEXTURE_COLORING_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int savingsVersionNumber = [[parameters objectForKey:@"versionnumber"] intValue];
            
            key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", textureid, booknumber, savingsVersionNumber];
            
            downscaleFactor = 4;
            
            break;
        }
            
        case TEXTURE_BLACK_AND_WHITE_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];
            key = [NSString stringWithFormat:@"textureID %d booknumber %d pagenumber %d", textureid, booknumber, pagenumber];
//            filePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
            
            downscaleFactor = 2;
            
            break;
        }
            
        case BUTTON_TEXTURE:{
            
            int buttonType = [[parameters objectForKey:@"buttontype"] intValue];
            int paintingMode = [[parameters objectForKey:@"paintingmode"] intValue];

            switch (buttonType) 
            {
                case BUTTON_CLEAR_PAINTING:
                case BUTTON_PREVIOUS:
                case BUTTON_NEXT:
                {
                    key = [NSString stringWithFormat:@"textureID %d buttonType %d", textureid, buttonType];
                    break;                        
                }
                    
                case BUTTON_CHANGE_PAINTING_MODE:{
                    
                    switch (paintingMode) {
                        case paintModeSimple:{
                            
                            key = [NSString stringWithFormat:@"textureID %d buttonType %d paintingmode %d", textureid, buttonType, paintingMode];
                            break;
                        }
                            
                        case paintModeMedium:{
                            key = [NSString stringWithFormat:@"textureID %d buttonType %d paintingmode %d", textureid, buttonType, paintingMode];
                            break;
                        }
                            
                        default: {
                            NSLog(@"%@ : %@ unexpected paint mode: %d", self, NSStringFromSelector(_cmd), paintingMode);
                            break;
                        }
                    }
                    
                    break;                        
                }
                case BUTTON_CUSTOM_COLOR:{   
                    key = [NSString stringWithFormat:@"textureID %d buttonType %d", textureid, buttonType];
                    break;                        
                }
                    
                case BUTTON_BACK_TO_GALLERY:{
                    key = [NSString stringWithFormat:@"textureID %d buttonType %d", textureid, buttonType];
                    break; 
                }
                    
                case BUTTON_SHOW_SAMPLE:{
//                    key = [NSString stringWithFormat:@"textureID %d buttonType %d booknumber %d pagenumber %d", textureid, buttonType, booknumber, pagenumber];
                    key = [NSString stringWithFormat:@"textureID %d buttonType %d", textureid, buttonType];
                    break;                     
                }

                default:{
                    NSLog(@"%@ : %@ WARINING!!! unexpected button type: %d", self, NSStringFromSelector(_cmd), buttonType);
                    break;
                }
            }

            
            break;
        }
            
            
        case CRAYON_RUNNING_LIGHT_1_TEXTURE:
        case CRAYON_RUNNING_LIGHT_2_TEXTURE:
        case CRAYON_HIGHLIGHT_TEXTURE:
        case CRAYON_RUNNING_SHADOW_TEXTURE:
        case TEXTURE_BACKGROUND:
        case STAR_TEXTURE:
        case CIRCLE_TEXTURE:
        case TEXTURE_PAPER:
        case TEXTURE_DRAWING_TOOLS_BOX:
        case ERASER_TEXTURE:
        case ERASER_SELECTED_TEXTURE:
        case ERASER_UNSELECTED_TEXTURE:
        case UNDO_TEXTURE:
        case SLIDER_BACKGROUND_TEXTURE:
        case TOOL_COLOR_AND_SIZE_INDICATOR_TEXTURE:
        case BRUSH_TEXTURE:
        case UNDO_LIGHT_ON_TEXTURE:
        case UNDO_LIGHT_OFF_TEXTURE:
        case GALLERY_BOOK_COVER_TEXTURE:
        case POLKA_TEXTURE:
        case RAINBOW_TOOL_TEXTURE:
        case RAINBOW_TOOL_INDICATOR_TEXTURE:
        {
            key = [NSString stringWithFormat:@"textureID %d", textureid];
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARINING!!! undexpected textureid: %d", self, NSStringFromSelector(_cmd), textureid);
            break;
        }
    }
    
    Texture *texture = [self.texturesDictionary objectForKey:key];
    
    if (texture && (texture.state == TEXTURE_STATE_USED || texture.state == TEXTURE_STATE_UNUSED)){
        retValue = texture.texturePointer;
        if (texture.state == TEXTURE_STATE_UNUSED){
            texture.state = TEXTURE_STATE_USED;
        }
        
        //                NSLog(@"%@ : %@ returning loaded texture %d", self, NSStringFromSelector(_cmd), texture.texturePointer);
    } else {
        
        //                NSLog(@"%@ : %@ texture doesn't exists or not loaded", self, NSStringFromSelector(_cmd));
        
        retValue = 0;
        
        if (shouldLoad){
            
            if (!texture){
                
                GLuint texNum;
                glGenTextures(1, &texNum);
                
                texture = [[Texture alloc] init];
                texture.state = TEXTURE_STATE_UNLOADED;
                texture.texturePointer = texNum;
                
//                NSLog(@"%@ : %@ texture %d created", self, NSStringFromSelector(_cmd), texNum);
                
                [self.texturesDictionary setObject:texture forKey:key];
                
            }
            
            if (texture.state != TEXTURE_STATE_LOADING){
                
                texture.state = TEXTURE_STATE_LOADING;
                
                NSString *filePath = [self pathForTextureID:textureid Parameters:parameters];
                
                
                if (!filePath) {
                    NSLog(@"%@ : %@ File not found", self, NSStringFromSelector(_cmd));
                }

                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                
                if (async){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        @autoreleasepool {
                            [self setupTexture:texture 
                                     WithImage:image 
                               DownscaleFactor:downscaleFactor 
                                     InContext:currentContext];
                        }
                    });  
                } else {
                    [self setupTexture:texture 
                             WithImage:image 
                       DownscaleFactor:downscaleFactor 
                             InContext:currentContext];
                }
            }
        }
    }

    return retValue;
    
//    return 0;
}


- (void)setupTexture:(Texture *)texture 
           WithImage:(UIImage *)imageToTex 
     DownscaleFactor:(int)downscale
         InContext:(EAGLContext *)currentContext
{    
    
//    NSLog(@"%@ : %@ start loading texture %d", self, NSStringFromSelector(_cmd), texture.texturePointer);

    
    CGImageRef spriteImage = imageToTex.CGImage;
    
    if (!spriteImage) {
        NSLog(@"%@ : %@ Failed to load image %@", self, NSStringFromSelector(_cmd), imageToTex);
        //        exit(1);
    }
    
    size_t imagewidth = CGImageGetWidth(spriteImage);
    size_t imageheight = CGImageGetHeight(spriteImage);
    
    int width = 1;
    int height = 1;
    
    
    BOOL resfound = NO;
    int i=1;
    while (!resfound) {
        if(i>=imagewidth) {
            width = i;
            resfound = YES;
        } else {
            i = i*2;
        }
    }
    
    resfound = NO;
    i=1;
    while (!resfound) {
        if(i>=imageheight) {
            height = i;
            resfound = YES;
        } else {
            i = i*2;
        }
    }
    
    height = height/downscale;
    width = width/downscale;
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
                                                       CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);    
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    dispatch_sync(GLCommandsQueue, ^{
        
        EAGLContext *oldContext = [EAGLContext currentContext];
        [EAGLContext setCurrentContext:currentContext];

        glBindTexture(GL_TEXTURE_2D, texture.texturePointer);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); 
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);

        glFlush();
        [EAGLContext setCurrentContext:oldContext];
    });
    
    texture.state = TEXTURE_STATE_USED;
    
    free(spriteData);
    
//    NSLog(@"%@ : %@ end loading texture %d", self, NSStringFromSelector(_cmd), texture.texturePointer);

}

- (NSString *)filePathForColoredPictureOfBookNumber:(int)booknumber VersionNumber:(int)versionnumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Book *book = [[BookManager sharedInstance] bookNumber:booknumber];
    Page *page;       
    int fileNumber = 0;
    BOOL filefound = NO;
    
    NSString *filePath;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0]; 
    
    for (int pagenumber = 0; pagenumber < [[BookManager sharedInstance] howManyPagesInBook:book]; pagenumber++){
        
        page = [[BookManager sharedInstance] pageNumber:pagenumber InBook:book];
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                            book.number, 
                            pagenumber];
        int numberOfVersions = [defaults integerForKey:numkey];
        
        
        for (int version = 0; version < numberOfVersions; version ++) {
            if (fileNumber == versionnumber){
                filePath = [NSString stringWithFormat:@"%@/SavedData/coloredSamples/book%d/page%d/version%d.png", documents, book.number, pagenumber, version];
//                NSLog(@"%@ : %@ file number %d found in book %d page %d", self, NSStringFromSelector(_cmd), fileNumber, book.number, pagenumber);
                filefound = YES;
                break;
            }
            fileNumber ++;
        }
        
        if (filefound)break;
    }
    
    if (!filefound) {
        NSLog(@"%@ : %@ warning! file for book %d version %d not found", self, NSStringFromSelector(_cmd), booknumber, versionnumber);
        return nil;
    }
    
    return filePath;
}

- (void)markUnusedTexture:(textureID)textureid
               Parameters:(NSDictionary *)parameters
{
    
    NSString *key;
    
    switch (textureid) {
            
        case TEXTURE_COLORING_PICTURE:{
            
            int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
            int savingsVersionNumber = [[parameters objectForKey:@"versionnumber"] intValue];
            
            key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", textureid, booknumber, savingsVersionNumber];

            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected texture id: %d", self, NSStringFromSelector(_cmd), textureid);
            break;
        }
    }
    
    Texture *texture = [self.texturesDictionary objectForKey:key];
    
    if (texture && (texture.state == TEXTURE_STATE_USED))
    {
        texture.state = TEXTURE_STATE_UNUSED;
        
//        NSLog(@"%@ : %@ texture %d marked as unused", self, NSStringFromSelector(_cmd), texture.texturePointer);
    }
}

- (void)shiftColorGalleryTexturesParameters:(NSDictionary *)parameters
{    
    
    int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
    int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];
    int pageversionnumber = [[parameters objectForKey:@"pageversionnumber"] intValue];
    
//    NSLog(@"booknumber = %d, pagenumber = %d, pageversionnumber = %d", booknumber, pagenumber, pageversionnumber);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int versionnumber = 0;
    
    for (int i=0; i<pagenumber; i++) {                          
        
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d", booknumber, i];
        versionnumber += [defaults integerForKey:numkey];
    }
    versionnumber += pageversionnumber;
    
    
    NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", booknumber];
    
    int maxSavingsNumber = [[defaults objectForKey:keytotal] intValue];

    
    for (int i = maxSavingsNumber-2; i >= 0; i--)
    {
        
        NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i];

        if (i > versionnumber) {
            NSString *keyNext = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i + 1];
            Texture *texture = [self.texturesDictionary objectForKey:key];
            Texture *textureNext = [self.texturesDictionary objectForKey:keyNext];
            
            if (texture && textureNext) {
                textureNext.texturePointer = texture.texturePointer;
            }
        } 
    }
}


- (void)deleteColorGalleryTextureParameters:(NSDictionary *)parameters
{    
    
    int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
    int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];
    int pageversionnumber = [[parameters objectForKey:@"pageversionnumber"] intValue];
    
//    NSLog(@"booknumber = %d, pagenumber = %d, pageversionnumber = %d", booknumber, pagenumber, pageversionnumber);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int versionnumber = 0;
    
    for (int i=0; i<pagenumber; i++) {                          
                          
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d", booknumber, i];
        versionnumber += [defaults integerForKey:numkey];
    }
    versionnumber += pageversionnumber;
    
//    NSLog(@"versionnumber = %d", versionnumber);
        
    NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, versionnumber];
    Texture *texture = [self.texturesDictionary objectForKey:key];
    if (texture)
    {
        GLuint texNumber = texture.texturePointer;
        dispatch_sync(GLCommandsQueue, ^{
            glDeleteTextures(1, &texNumber);
        });
        
        [self.texturesDictionary removeObjectForKey:key];
        [texture release];
    }
}

- (void)deleteColorGalleryTexturesInRightParameters:(NSDictionary *)parameters
{    
    
    int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
    int pagenumber = [[parameters objectForKey:@"pagenumber"] intValue];
    int pageversionnumber = [[parameters objectForKey:@"pageversionnumber"] intValue];
    
    NSLog(@"booknumber = %d, pagenumber = %d, pageversionnumber = %d", booknumber, pagenumber, pageversionnumber);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int versionnumber = 0;
    
    for (int i=0; i<pagenumber; i++) {                          
        
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d", booknumber, i];
        versionnumber += [defaults integerForKey:numkey];
    }
    
    NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                        booknumber, 
                        pagenumber];
    versionnumber += [defaults integerForKey:numkey];
    
    NSLog(@"versionnumber = %d", versionnumber);
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", booknumber];
    
    int maxSavingsNumber = [[defauls objectForKey:keytotal] intValue];
    
    int startI;
    if (versionnumber == 0) {
        startI = 0;   
    } else {
        startI = versionnumber - 1;
    }
    
    for (int i = startI; i<maxSavingsNumber; i++){    
        NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i];
        Texture *texture = [self.texturesDictionary objectForKey:key];
        if (texture)
        {
            GLuint texNumber = texture.texturePointer;
            dispatch_sync(GLCommandsQueue, ^{
                glDeleteTextures(1, &texNumber);
            });
            
            [self.texturesDictionary removeObjectForKey:key];
            [texture release];
        }
    }
}

- (void)deleteAllColorGalleryTexturesParameters:(NSDictionary *)parameters
{    
 
    int booknumber = [[parameters objectForKey:@"booknumber"] intValue];
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", booknumber];
    
    int maxSavingsNumber = [[defauls objectForKey:keytotal] intValue];
    
    for (int i=0; i<maxSavingsNumber; i++){    
        NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i];
        Texture *texture = [self.texturesDictionary objectForKey:key];
        if (texture)
        {
            GLuint texNumber = texture.texturePointer;
            dispatch_sync(GLCommandsQueue, ^{
                glDeleteTextures(1, &texNumber);
            });
            
            [self.texturesDictionary removeObjectForKey:key];
            [texture release];
        }
    }
}

- (void)deleteAllUnusedTextures
{
    
    for (NSString *key in [self.texturesDictionary allKeys]){
        Texture *texture = [self.texturesDictionary objectForKey:key];
        
        if (texture.state == TEXTURE_STATE_UNUSED){
            GLuint texNumber = texture.texturePointer;
            
//            NSLog(@"%@ : %@ delete texture %d", self, NSStringFromSelector(_cmd), texNumber);
            
            dispatch_sync(GLCommandsQueue, ^{
                glDeleteTextures(1, &texNumber);
            });
            
            [self.texturesDictionary removeObjectForKey:key];
            [texture release];
        }
    }
}

- (void)deleteUnusedColorGalleryTexturesForBook:(int)booknumber
{
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", booknumber];
    
    for (int i=0; i<[defauls integerForKey:keytotal]; i++){
        
        NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i];
        Texture *texture = [self.texturesDictionary objectForKey:key];
        if (texture && (texture.state == TEXTURE_STATE_UNUSED)){
            texture.state = TEXTURE_STATE_UNLOADING;
            GLuint texNum = texture.texturePointer;
            glDeleteTextures(1, &texNum);
            NSLog(@"%@ : %@ texture %d deleted", self, NSStringFromSelector(_cmd), texture.texturePointer);
            texture.state = TEXTURE_STATE_UNLOADED;
        }
    }
}


#pragma mark - Shaders

- (GLuint) getProgram:(programID)programid{
    GLuint retValue;
            
    NSString *key = [NSString stringWithFormat:@"programid %d", programid];
    NSNumber *progNumber = [self.programsDictionary objectForKey:key];
    retValue = [progNumber unsignedIntValue];
    
    if (retValue == 0){
        
        retValue = [self loadProgram:programid];
        [self.programsDictionary setObject:[NSNumber numberWithUnsignedInt:retValue] forKey:key];
//        NSLog(@"%@ : %@ program %d loaded", self, NSStringFromSelector(_cmd), retValue);
    }

    return retValue;
}

- (GLuint)loadProgram:(programID)programid{
    GLuint program, vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    switch (programid) {
            
        case PROGRAM_BASIC_LIGHTNING:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"BasicLightingShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"BasicLightingShader" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_FILLING:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"FillingShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"FillingShader" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_FINAL_PICTURE:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"FinalPictureShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"FinalPictureShader" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_FINAL_PICTURE_WITH_SHADING:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"FinalPictureWithShading" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"FinalPictureWithShading" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_DRAW_BRUSH_LINE:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"DrawBrushLineShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"DrawBrushLineShader" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_SIMPLE_TEXTURING:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"SimpleTexturingShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"SimpleTexturingShader" ofType:@"fsh"];
            break;            
        }
            
        case PROGRAM_TEXTURING_PLUS_ALPHA:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"TexturePlusAlphaShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"TexturePlusAlphaShader" ofType:@"fsh"];
            break;
        }
            
        case PROGRAM_TEXTURING_PLUS_COLOR_CHANGE:{
            vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"TexturePlusColorChangeShader" ofType:@"vsh"];
            fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"TexturePlusColorChangeShader" ofType:@"fsh"];
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARINING!!! unexpected programID: %d", self, NSStringFromSelector(_cmd), programid);
            break;
        }
    }
    
//    NSLog(@"vertShaderPathname = %@", vertShaderPathname);
//    NSLog(@"fragShaderPathname = %@", fragShaderPathname);
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);   
    
    [self bindAttributeLocations:programid program:program];
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return 0;
    }
    
    [self getUniformLocations:programid program:program];
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return program;
}



- (void)bindAttributeLocations:(programID)programid program:(GLuint)program {
    switch (programid) {
        case PROGRAM_BASIC_LIGHTNING:{
            glBindAttribLocation(program, BASIC_LIGHTING_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, BASIC_LIGHTING_ATTRIB_TEX_COORDS, "texCoords");
            
            break;
        }
            
        case PROGRAM_FILLING:{
            
            glBindAttribLocation(program, FILLING_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, FILLING_ATTRIB_TEX_COORDS, "texCoords");
            glBindAttribLocation(program, FILLING_ATTRIB_CIRCLE_TEX_COORDS, "circleTexCoords");

            break;
        }
            
        case PROGRAM_FINAL_PICTURE:{
            glBindAttribLocation(program, FINAL_PICTURE_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, FINAL_PICTURE_ATTRIB_TEX_COORDS, "texCoords");
            
            break;
        }

        case PROGRAM_FINAL_PICTURE_WITH_SHADING:{
            glBindAttribLocation(program, FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS, "texCoords");
            
            break;
        }
            
        case PROGRAM_DRAW_BRUSH_LINE:{
            glBindAttribLocation(program, DRAW_BRUSH_LINE_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, DRAW_BRUSH_LINE_ATTRIB_TEX_COORDS, "texCoords");

            break;
        }
        
        case PROGRAM_SIMPLE_TEXTURING:{
            glBindAttribLocation(program, SIMPLE_TEXTURING_ATTRIB_VERTEX, "position");
                        
            break;
        }
            
        case PROGRAM_TEXTURING_PLUS_ALPHA:{
            glBindAttribLocation(program, TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, "position");

            break;
        }
            
            
        case PROGRAM_TEXTURING_PLUS_COLOR_CHANGE:{
            
            glBindAttribLocation(program, PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_VERTEX, "position");
            glBindAttribLocation(program, PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_TEX_COORDS, "texCoords");
            
            break;
        }
            
        default:{
            
            NSLog(@"%@ : %@ WARINING!!! unexpected programID: %d", self, NSStringFromSelector(_cmd), programid);
            break;
        }
    }
}

- (void)getUniformLocations:(programID)programid program:(GLuint)program {
    switch (programid) {
        case PROGRAM_BASIC_LIGHTNING:{
            basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");   
            basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_TEXTURE] = glGetUniformLocation(program, "texture");  
            basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE] = glGetUniformLocation(program, "paperTexture");  
            basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_ROTATION] = glGetUniformLocation(program, "rotation");  
            
            break;
        }
            
        case PROGRAM_FILLING:{
            filling_uniforms[FILLING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");      
            filling_uniforms[FILLING_UNIFORM_AREAS_TEXTURE] = glGetUniformLocation(program, "areasTexture");      
            filling_uniforms[FILLING_UNIFORM_CIRCLE_TEXTURE] = glGetUniformLocation(program, "circleTexture");      
            filling_uniforms[FILLING_UNIFORM_CURRENT_AREA] = glGetUniformLocation(program, "currentArea");      
            filling_uniforms[FILLING_UNIFORM_BRUSH_COLOR] = glGetUniformLocation(program, "brushColor");
            
            break;
        }
            
        case PROGRAM_FINAL_PICTURE:{
            final_picture_uniforms[FINAL_PICTURE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");
            final_picture_uniforms[FINAL_PICTURE_UNIFORM_TEXTURE] = glGetUniformLocation(program, "originalImageTexture");
            final_picture_uniforms[FINAL_PICTURE_UNIFORM_DRAWING_TEXTURE] = glGetUniformLocation(program, "drawingTexture");
            final_picture_uniforms[FINAL_PICTURE_UNIFORM_PAPER_TEXTURE] = glGetUniformLocation(program, "paperTexture");
            
            break;
        }
            
        case PROGRAM_FINAL_PICTURE_WITH_SHADING:{
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_TEXTURE] = glGetUniformLocation(program, "originalImageTexture");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_DRAWING_TEXTURE] = glGetUniformLocation(program, "drawingTexture");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_PAPER_TEXTURE] = glGetUniformLocation(program, "paperTexture");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_CURRENT_AREA] = glGetUniformLocation(program, "currentArea");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_DISCOLORING_CONSTANT] = glGetUniformLocation(program, "discoloringCoefficient");
            final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_HIGHLIGHT_CONSTANT] = glGetUniformLocation(program, "highlightCoefficient");
                                                
            break;
        }

        case PROGRAM_DRAW_BRUSH_LINE:{
        
            draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");  
            draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_BRUSH_TEXTURE] = glGetUniformLocation(program, "brushTexture");  
            draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_COLOR] = glGetUniformLocation(program, "brushColor");  
            draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_TEXTURE] = glGetUniformLocation(program, "texture");  
            draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_CURRENT_AREA] = glGetUniformLocation(program, "currentArea"); 
            
            break;
        }
            
        case PROGRAM_SIMPLE_TEXTURING:{
            simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");  
            simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE] = glGetUniformLocation(program, "texture"); 

            break;
        }
            
        case PROGRAM_TEXTURING_PLUS_ALPHA:{
            texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");  
            texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE] = glGetUniformLocation(program, "texture");  
            texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA] = glGetUniformLocation(program, "alpha"); 
            
            break;
        }
            
        case PROGRAM_TEXTURING_PLUS_COLOR_CHANGE:{            
            texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");
            texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_TEXTURE] = glGetUniformLocation(program, "texture");
            texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_NEW_COLOR] = glGetUniformLocation(program, "newColor");
            
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ WARINING!!! unexpected programID: %d", self, NSStringFromSelector(_cmd), programid);
            break;
        }
    }
}



- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"%@ : %@ Failed to load vertex shader", self, NSStringFromSelector(_cmd));
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}


- (BOOL)linkProgram:(GLuint)prog{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}


#pragma mark - Scenes

- (void) loadResourcesForScene:(sceneID)sceneid
                    Parameters:(NSDictionary *)parameters
                     InContext:(EAGLContext *)context
{
    switch (sceneid) {
        case SCENE_SELECT_PICTURE:{
            int currentBookNumber = [[parameters objectForKey:@"booknumber"] intValue];
            
            for (int i=0; i<10; i++){
                NSDictionary *param = 
                    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:currentBookNumber], @"booknumber",
                                                               [NSNumber numberWithInt:i], @"pagenumber", 
                                                                nil];

                [self getTexture:TEXTURE_BLACK_AND_WHITE_PICTURE
                      Parameters:param
                       InContext:context
                      ShouldLoad:YES
                           Async:NO];
            }
            
            [self getTexture:TEXTURE_BACKGROUND 
                  Parameters:nil 
                   InContext:context 
                  ShouldLoad:YES 
                       Async:NO];
            
            [self getTexture:TEXTURE_PAPER
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            for (int verNumber = 0; verNumber < COLORED_SHEET_NEIGHBOORS_COUNT_RIGHT; verNumber++){
                
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt: currentBookNumber], @"booknumber", 
                                            [NSNumber numberWithInt: verNumber], @"versionnumber",
                                            nil];
                
                [self getTexture:TEXTURE_COLORING_PICTURE 
                      Parameters:param
                       InContext:context
                      ShouldLoad:YES
                           Async:NO];
            }
            
            break;
        }
            
        case SCENE_PAINTING:{
            
            [self getTexture:TEXTURE_DRAWING_TOOLS_BOX 
                  Parameters:nil 
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:RAINBOW_TOOL_TEXTURE 
                  Parameters:nil 
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:RAINBOW_TOOL_INDICATOR_TEXTURE 
                  Parameters:nil 
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];

            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_CHANGE_PAINTING_MODE], @"buttontype", 
                                        [NSNumber numberWithInt:paintModeSimple], @"paintingmode", nil];
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            NSDictionary *param2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_CHANGE_PAINTING_MODE], @"buttontype", 
                                                                              [NSNumber numberWithInt:paintModeMedium], @"paintingmode", nil];
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param2
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            NSDictionary *param3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_PREVIOUS], @"buttontype", nil];
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param3
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            NSDictionary *param4 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_NEXT], @"buttontype", nil];
            
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param4
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            NSDictionary *param5 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_CUSTOM_COLOR], @"buttontype", nil];
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param5
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            NSDictionary *param6 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:BUTTON_CLEAR_PAINTING], @"buttontype", nil];
            
            [self getTexture:BUTTON_TEXTURE
                  Parameters:param6
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            
            [self getTexture:ERASER_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES 
                       Async:NO];
            
            [self getTexture:CRAYON_HIGHLIGHT_TEXTURE 
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:CRAYON_RUNNING_LIGHT_1_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:CRAYON_RUNNING_LIGHT_2_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:CRAYON_RUNNING_SHADOW_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:CIRCLE_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:STAR_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
            
            [self getTexture:SLIDER_BACKGROUND_TEXTURE
                  Parameters:nil
                   InContext:context
                  ShouldLoad:YES
                       Async:NO];
             

            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected scene id: %d", self, NSStringFromSelector(_cmd), sceneid);
            break;
        }
    }
    
}


;//    
//    textureID textureid = TEXTURE_BLACK_AND_WHITE_PICTURE;
//    
//    for (int i=0; i<10; i++){
//    
//        NSString *key = [NSString stringWithFormat:@"textureID %d index1 %d index2 %d", textureid, index1, i];
//        NSNumber *texNumber = [self.texturesDictionary objectForKey:key];
//        GLuint tn = [texNumber unsignedIntValue];
//        
//        if (tn == 0){
//            
//            NSString *filePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], index1, i];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//            
//            glGenTextures(1, &tn);
////            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [self setupTexture:tn WithImage:image DownscaleFactor:2];
////            });
//            
//            
//            [self.texturesDictionary setObject:[NSNumber numberWithUnsignedInt:tn] forKey:key];
//        }
//    }
//}

- (void) deleteAllResources{
    
    //TO-DO set resourceLoading context here
    
    dispatch_sync(GLCommandsQueue, ^{
        
        for (NSString *key in [self.texturesDictionary allKeys]){
            Texture *texture = [self.texturesDictionary objectForKey:key];
            
            GLuint texNumber = texture.texturePointer;
                
//            NSLog(@"%@ : %@ delete texture %d", self, NSStringFromSelector(_cmd), texNumber);
                
            glDeleteTextures(1, &texNumber);
            
            [self.texturesDictionary removeObjectForKey:key];
            [texture release];
        }
        
//        for (Texture *texture in [self.texturesDictionary allValues]){
//            if ([texture isKindOfClass:[Texture class]]){
//                GLuint texNumber = texture.texturePointer;
//                glDeleteTextures(1, &texNumber);
//                [texture release];
//            } else {
//                NSLog(@"STOP!");
//            }
//        }
//        [self.texturesDictionary removeAllObjects];    

    //    NSLog(@"%@ : %@ self.programsDictionary: %@", self, NSStringFromSelector(_cmd), self.programsDictionary);
        
        for (NSNumber *programNumber in [self.programsDictionary allValues]){
            GLuint program = [programNumber unsignedIntValue];
    //        NSLog(@"%@ : %@ deleting program: %d", self, NSStringFromSelector(_cmd), program);
            glDeleteProgram(program);
        }
        [self.programsDictionary removeAllObjects];
    });
}

- (void)deleteColorGalleryTexturesForScrollingInBookNumber:(int)booknumber  
                                           FromSheetNumber:(int)numberFrom
                                                   ToSheet:(int)numberTo
{
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", booknumber];
    
    for (int i=0; i<[defauls integerForKey:keytotal]; i++){
    
        if( !( (i > numberFrom - 2 && i < numberFrom + 2) || (i > numberTo - 2 && i < numberTo + 2) ) ){
        
            NSString *key = [NSString stringWithFormat:@"textureID %d booknumber %d versionnumber %d", TEXTURE_COLORING_PICTURE, booknumber, i];
            NSNumber *texNumber = [self.texturesDictionary objectForKey:key];
            GLuint texture = [texNumber unsignedIntValue];
            glDeleteTextures(1, &texture);
            [self.texturesDictionary removeObjectForKey:key];
        }
   }
}

#pragma mark - Singleton methods

static ResourceManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (ResourceManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        counterOfLoadingTextures = 0;
        GLCommandsQueue = dispatch_queue_create("ru.Aplica.DynamicTextures.GLCommandsQueue", NULL);
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    
    [texturesDictionary release];
    [programsDictionary release];
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

@end
