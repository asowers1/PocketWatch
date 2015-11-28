//
//  NSFileManager+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//
// ARC_YES


@interface NSFileManager (Fuzz)

/**
 Use this directory to store critical user documents and app data files. Critical data is any data that cannot be recreated by your app, 
 such as user-generated content.The contents of this directory can be made available to the user through file sharing. The contents of
 this directory are backed up by iTunes.
 */
+(NSString *)documentDirectoryPath; 
+(NSString *)documentsDirectoryPath;
+(NSString *)documentsDirectoryPathToFile:(NSString*)fileName;
/**
 Use this directory to access files that your app was asked to open by outside entities. Specifically, the Mail program places email 
 attachments associated with your app in this directory; document interaction controllers may also place files in it. Your app can read 
 and delete files in this directory but cannot create new files or write to existing files. If the user tries to edit a file in this 
 directory, your app must silently move it out of the directory before making any changes. The contents of this directory are backed up by 
 iTunes.
 */
+(NSString *)mailDirectoryPath;
+(NSString *)mailDirectoryPathToFile:(NSString*)fileName;


/**
 This directory is the top-level directory for files that are not user data files. You typically put files in one of several standard 
 subdirectories but you can also create custom subdirectories for files you want backed up but not exposed to the user. You should not use 
 this directory for user data files. The contents of this directory (with the exception of the Caches subdirectory) are backed up by 
 iTunes.
*/
+(NSString *)libraryDirectoryPath;
+(NSString *)libraryDirectoryPathToFile:(NSString*)fileName;

/**
 In iOS 5.0 and earlier, put support files in the <Application_Home>/Library/Caches directory to prevent them from being backed up
 */
+(NSString *)cachesDirectoryPath;
+(NSString *)cachesDirectoryPathToFile:(NSString*)fileName;



/**
 In iOS 5.0.1 and later, put support files in the <Application_Home>/Library/Application Support directory and apply the
 com.apple.MobileBackup extended attribute to them. This attribute prevents the files from being backed up to iTunes or iCloud. If you
 have a large number of support files, you may store them in a custom subdirectory and apply the extended attribute to just the directory.
 */
+(NSString *)applicationSupportDirectoryPath;
+(NSString *)applicationSupportDirectoryPathToFile:(NSString*)fileName;

/**
 Use this directory to write temporary files that do not need to persist between launches of your app. Your app should remove files from 
 this directory when it determines they are no longer needed. (The system may also purge lingering files from this directory when your app 
 is not running.)
 */
+(NSString *)tmpDirectoryPath;
+(NSString *)tmpDirectoryPathToFile:(NSString*)fileName;

/**
 *  The path to the main application bundle containing resources
 */
+(NSString *)bundleDirectoryPath;
+(NSString *)bundleDirectoryPathToFile:(NSString*)fileName;
/**
 *  Determine if there is a file at the given path
 *  This is a bit different than the instance method as
 *  That will return YES for directories but this will not
 *
 *  @param inPath the path in question
 *
 *  @return YES if the path points tp a file
 */
+ (BOOL)fileExistsAtPath:(NSString*)inPath;


/**
 *  Determine if there is a file at the given path
 *
 *  @param inPath the path in question
 *
 *  @return YES if the path points tp a directory
 */
+ (BOOL)directoryExistsAtPath:(NSString*)inPath;

/**
 *  Creates an array of strings representing the items
 * contained within the directory at the given path
 *
 *  @param inPath the directoy
 *
 *  @return the list of items
 */
+ (NSArray *)contentsOfDirectoryAtPath:(NSString*)inPath;


/**
 *  Print to the console the list of items at the given directory
 *  This exists entirely for debugging perposes
 *
 *  @param directory the directory to be inspected
 */
+ (void)logContentsOfDirectoryAtPath:(NSString*)directory;

/**
 *  Create a new directory with intermediate directories
 *  at the given path
 *
 *  @param inPath the destination
 *
 *  @return success or failure
 */
+ (BOOL)createDirectoryAtPath:(NSString*)inPath;


/**
 *  Remove either a file or directory at the given path
 *
 *  @param inPath the path of the item to be removed
 *
 *  @return success or failure
 */
+ (BOOL)removeItemAtPath:(NSString*)inPath;


/**
 *  Create a new copy of the item at the source path
 *  and place it at the destination path
 *
 *  @param inSource      the path to the original item
 *  @param inDestination the path to the copy of the item
 *
 *  @return success or failure
 */
+ (BOOL)copyItemAtPath:(NSString*)inSource toPath:(NSString*)inDestination;

/**
 *  Change the location of an item at the source path
 *  to be the destination path
 *
 *  @param inSource      the original location
 *  @param inDestination the final location
 *
 *  @return succes or failure
 */
+ (BOOL)moveItemAtPath:(NSString*)inSource toPath:(NSString*)inDestination;


/**
 *  Adding this flag prevents iCloud form backing up the file at the given path
 *
 *  @param inPath the location of the file skipping back up
 */
+ (void)addSkipBackupAttributeToItemAtPath:(NSString*)inPath;

/**
 *  Adding this flag prevents iCloud form backing up the file at the given path.
 *
 *  @param inURL A URL for a file system path.
 */
+ (void)addSkipBackupAttributeToItemAtURL:(NSURL *)inURL;

@end
