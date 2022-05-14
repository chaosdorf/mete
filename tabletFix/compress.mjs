import { readdir, readFile, writeFile } from 'node:fs/promises';
import { minify } from 'terser';

const directory = 'assets';

const files = await readdir('assets');
const jsFiles = files.filter((fileName) => fileName.endsWith('.js'));

const fileCodeMap = {};
await Promise.all(
  jsFiles.map(async (fileName) => {
    fileCodeMap[`${directory}/${fileName}`] = await readFile(
      `${directory}/${fileName}`,
      'utf8'
    );
  })
);

const minifyOptions = {
  compress: true,
  ie8: true,
  safari10: true,
  format: {
    comments: false,
  },
};

await Promise.all(
  Object.keys(fileCodeMap).map(async (filePath) => {
    const { code } = await minify(fileCodeMap[filePath], minifyOptions);
    await writeFile(filePath, code);
  })
);
