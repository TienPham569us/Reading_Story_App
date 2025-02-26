import archiver from 'archiver';
import * as fs from 'fs';
import { DataSourceManager } from '~/models/DataSourceManagement/DataSourceManager';
import { IDataSourcePlugin } from '~/models/DataSourceManagement/IDataSourcePlugin';
import { deleteFile } from '~/utils/FileUtility';
import { getNumberValueFromString, removeInvalidCharacter } from '~/utils/StringUtility';
import { wrapRequestHandler } from '~/utils/handlers';
import { NextFunction, Request, Response } from 'express';
import { ParamsDictionary } from 'express-serve-static-core';
import { FileExtensionAudioManager } from '~/models/FileExtensionAudioManagement/FileExtensionAudioManager';
import { ContentStory } from '~/models/Interfaces/ContentStory';
import { IFileExtensionAudioPlugin } from '~/models/FileExtensionAudioManagement/IFileExtensionAudioPlugin';

// This function is used for handle request download a chapter of a story
export const downloadChapter = wrapRequestHandler(
  async (req: Request<ParamsDictionary, any>, res: Response, next: NextFunction) => {
    // Get number of chap
    const chap: string = req.query.chap?.toString() || '';

    // Get title of story
    let title: string = req.query.title?.toString() || '';

    // Get source of story
    const source: string = req.query.datasource?.toString() || '';

    // Get file formatted client want to download
    const fileExtensionType: string = req.query.type?.toString() || '';

    const startTime: string = req.query.start?.toString() || '0';
    const endTime: string = req.query.end?.toString() || '0';

    const startTimeNumber: number = getNumberValueFromString(startTime);
    const endTimeNumber: number = getNumberValueFromString(endTime);

    console.log('source: ', source);
    console.log('title: ', title);
    console.log('chap: ', chap);
    console.log('fileExtensionType: ', fileExtensionType);
    console.log('startTimeNumber: ', startTimeNumber);
    console.log('endTimeNumber: ', endTimeNumber);

    if (source != null) {
      // Get plugin to crawl data of chapter of story
      const dataSourceManager: DataSourceManager = DataSourceManager.getInstance();
      const plugin: IDataSourcePlugin | null = dataSourceManager.select(`${source}Plugin`);
      if (plugin != null) {
        // Get result after crawling data
        const result: ContentStory | null = await plugin.contentStory(title, chap);

        if (result != null) {
          //result.chap = removeInvalidCharacter(result.chap);
          title = removeInvalidCharacter(title);

          // Get plugin support download formatted file client want and plugin support download txt file
          const fileExtensionManager: FileExtensionAudioManager =
            FileExtensionAudioManager.getInstance();

          const fileExtensionPlugin: IFileExtensionAudioPlugin | null = fileExtensionManager.select(
            `${fileExtensionType}AudioPlugin`
          );
          //   const fileTxtExtensionPlugin: IFileExtensionAudioPlugin | null =
          //     fileExtensionManager.select('HTMLComicsPlugin'); && fileTxtExtensionPlugin != null

          if (fileExtensionPlugin != null) {
            // Create file that has formatted file client want
            //const stringWithoutSpaces = result.content.replace(/\s/g, '%20');
            const filePath = await fileExtensionPlugin.createFile(
              title,
              chap,
              result.content.replace(/\s/g, '%20'),
              startTimeNumber,
              endTimeNumber,
              result.chapterTitle ? result.chapterTitle : ''
            );

            // Create file that has txt file
            // const fileTxtPath = await fileTxtExtensionPlugin.createFile(
            //   title,
            //   chap,
            //   result.content
            // );

            // Create file names of two files
            const fileName = `${title}_${chap}.${fileExtensionType.toLowerCase()}`;
            // const fileTxtName = `${title}_${chap}.html`;

            // Create json meta data of file .zip
            const files = [
              { name: fileName, path: filePath }
              //  { name: fileTxtName, path: fileTxtPath }
            ];

            // File name for the ZIP file
            const zipFileName = `${title}_${chap}.zip`;

            // Set the appropriate headers
            res.set({
              'Content-Disposition': `attachment; filename="${zipFileName}"`,
              'Content-Type': 'application/zip'
            });

            // Create file zip
            const zip = archiver('zip');
            const output = fs.createWriteStream(zipFileName);
            // zip.pipe(res);
            zip.pipe(output);

            // Archive downloaded file into file zip
            files.forEach((file) => {
              const fileStream = fs.createReadStream(file.path);
              zip.append(fileStream, { name: file.name });
            });

            // Send file zip
            zip.finalize();
            output.on('close', () => {
              res.download(zipFileName, zipFileName, (err) => {
                if (err) {
                  console.error('Error while downloading:', err);
                  res.status(500).send('Error while downloading the file');
                } else {
                  // Delete file after downloading successfully
                  deleteFile(filePath);
                  //deleteFile(fileTxtPath);

                  fs.unlink(zipFileName, (err) => {
                    if (err) {
                      console.error('Error while deleting the file:', err);
                    }
                  });
                }
              });
            });
          }
        } else {
          res.json({ success: false, message: 'cannot get content' });
        }
      } else {
        res.json({ success: false, message: 'plugin source errors' });
      }
    } else {
      res.json({ success: false, message: 'source is not valid' });
    }
  }
);

// This function is used for handle request get all file formatted that server support to download
export const listFileExtension = wrapRequestHandler(
  async (req: Request<ParamsDictionary, any>, res: Response, next: NextFunction) => {
    const fileExtensionManager: FileExtensionAudioManager = FileExtensionAudioManager.getInstance();
    const nameFileExtension: string[] = fileExtensionManager.getAllPluginName();
    const data: object = {
      length: nameFileExtension.length,
      names: nameFileExtension
    };
    res.json(data);
  }
);
