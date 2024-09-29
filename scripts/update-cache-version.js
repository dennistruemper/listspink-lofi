const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "..", "public", "serviceWorker.js");

fs.readFile(filePath, "utf8", (err, data) => {
  if (err) {
    console.error("Error reading file:", err);
    return;
  }

  const versionRegex = /const cacheName = "ch?ache-v(\d+)";/;
  const match = data.match(versionRegex);

  if (match) {
    const currentVersion = parseInt(match[1], 10);
    const newVersion = currentVersion + 1;
    const updatedData = data.replace(
      versionRegex,
      `const cacheName = "cache-v${newVersion}";`
    );

    fs.writeFile(filePath, updatedData, "utf8", (writeErr) => {
      if (writeErr) {
        console.error("Error writing file:", writeErr);
      } else {
        console.log(`Cache version updated to v${newVersion}`);
      }
    });
  } else {
    console.error("Cache version not found in the file");
  }
});
