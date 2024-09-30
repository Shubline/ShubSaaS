controladdin PDF
{
    // Scripts = 'src/script/pdf-lib.min.js',
    // 'src/script/download.js',
    // 'src/script/scripts.js';

    Scripts = 'Scripts/MergePDF-Scripts/pdf-lib.min.js',
    'Scripts/MergePDF-Scripts/download.js',
    'Scripts/MergePDF-Scripts/scripts.js';

    HorizontalShrink = true;
    VerticalShrink = true;

    MaximumHeight = 0;
    MaximumWidth = 0;

    RequestedHeight = 0;
    RequestedWidth = 0;

    event DownloadPDF(stringpdffinal: text);
    procedure createPdf();
    procedure MergePDF(JObjectToMerge: text);
}