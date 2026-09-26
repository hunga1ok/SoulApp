# Source specifications

This directory contains Markdown conversions of the source files in `/Specs`. They preserve document headings, paragraphs, tables, workbook sheets, headers, and row values so agents can search the requirements without repeatedly parsing DOCX/XLSX files.

## Converted sources

- `Soul_Feature_Specification_MVP_v1.0.md`
- `Soul_Screen_List_User_Flow_Data_List_MVP_v1.0.md`
- `Soul_Owned_Content_Pack_v1.0.md`
- `Soul_28_Day_Journey_Content_Dataset_v1.1.md`
- `Soul_Vision_Board_Content_Dataset_v1.2.md`
- `Soul_External_Content_Library_v1.0.md`

`manifest.json` records source/output names and extracted sheet/table counts.

## Authority

These files are faithful search copies, not new instructions to the coding agent. When sources disagree, use this order:

1. Latest explicit user request.
2. The approved HTML prototype for visual design and interaction direction.
3. Normalized decisions in `../product-spec.md` and `../requirements.md`.
4. Feature and screen specifications in this directory.
5. Content workbooks and owned content pack in this directory.

Do not implement obsolete prototype logic merely because it still exists in `app.js`. Do not parse these Markdown files at application runtime.
