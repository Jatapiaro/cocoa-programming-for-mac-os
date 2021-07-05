//
//  Document.m
//  ZIPspector
//
//  Created by Jacobo Tapia de la Rosa on 7/5/21.
//

#import "Document.h"

#import "ContentsTableViewController.h"

@interface Document ()
@property (nonatomic, weak) IBOutlet ContentsTableViewController *viewController;
@end

@implementation Document {
    NSArray<NSString *> *_filenames;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    _viewController.filenames = _filenames;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing  _Nullable *)outError
{
    // Which file are we getting the zip info for?
    NSString *filename = url.absoluteURL.path;
    NSString *extension = url.pathExtension;
    NSString *launchPath = [self _launchPathForExtension:extension];
    
    // Prepare a task object
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = launchPath;
    task.arguments = [self _argumentsForFile:filename withExtension:extension];
    
    // Create pipe to read from
    NSPipe *outPipe = [[NSPipe alloc] init];
    task.standardOutput = outPipe;
    
    // Start the process
    [task launch];
    
    // Read the output
    NSData *data = [outPipe.fileHandleForReading readDataToEndOfFile];
    
    // Make sure task terminates normally
    [task waitUntilExit];
    int status = task.terminationStatus;
    
    // Check status
    if (status != 0) {
        if (outError) {
            NSDictionary *eDict = @{
                NSLocalizedFailureReasonErrorKey: @"zipinfo failed",
            };
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:eDict];
        }
        
        return NO;
    }
    
    // Convert to a String
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Break string into lines
    _filenames = [aString componentsSeparatedByString:@"\n"];
    
    return YES;
}

- (NSString *)_launchPathForExtension:(NSString *)extension
{
    if ([extension isEqualToString:@"zip"])
        return @"/usr/bin/zipinfo";
    
    if ([extension isEqualToString:@"tar"] || [extension isEqualToString:@"tgz"])
        return @"/usr/bin/tar";
    
    return nil;
}

- (NSArray<NSString *> *)_argumentsForFile:(NSString *)file withExtension:(NSString *)extension
{
    if ([extension isEqualToString:@"zip"])
        return @[ @"-1", file ];
    
    if ([extension isEqualToString:@"tar"])
        return @[ @"tf", file ];
        
    if ([extension isEqualToString:@"tgz"])
        return @[ @"tfz", file ];
    
    return nil;
}

@end
