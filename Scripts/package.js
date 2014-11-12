var fs = require('fs');
var path = require('path');
var cheerio = require('cheerio');
var child_process = require('child_process');
var EasyZip = require('easy-zip').EasyZip;

child_process.exec("git rev-parse HEAD", function(error, stdout, stderr) {
    if (error)
        throw error;

    var commitHash = stdout;
    var shortCommit = commitHash.substr(0, 7);

    child_process.exec("git show -s --format=%ci " + commitHash, function(
            error, stdout, stderr) {
        if (error)
            throw error;

        var fullDate = stdout;
        var regex = /^(\d{4})-(\d{2})-(\d{2})/;
        var match = regex.exec(fullDate);
        var isoDate = match[0];
        var date = match[3] + "." + match[2] + "." + match[1];

        fs.readFile("../Regelwerk/Regelwerk.html", function(error, contents) {
            if (error)
                throw error;

            var $ = cheerio.load(contents);

            $("#revision").text("Version " + shortCommit + " (" + date + ")");

            var zip = new EasyZip();
            zip.file("Regelwerk.html", $.html());
            zip.zipFolder("../Regelwerk/Ressourcen", function() {

                zip.filter(function(relativePath, file) {
                    return path.basename(relativePath).match(/^\./);
                }).forEach(function(item) {
                    zip.remove(item.name);
                })

                zip.writeToFile("../../Regelwerk " + isoDate + " "
                        + shortCommit + ".zip");
            });
        });
    });
});
