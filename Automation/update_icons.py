#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
    1) Downloads the current icon font file
    2) Replaces the current icon font file
    3) Regenerates a swift file to access the font using the information from orbit-icons.svg
"""

import sys
import os
import pathlib
import shutil
import xml.etree.ElementTree as elementTree
import urllib.request

icons_filename = 'Icons.swift'

source_header = '''
// Generated by 'Automation/update_icons.py'
'''

source_template = source_header + '''public extension Icon {{

    enum Symbol: CaseIterable, Equatable {{
{cases}

        public var value: String {{
            switch self {{
{values}
            }}
        }}
    }}
}}
'''

def kebab_case_to_camel_case(string):
    head, *tail = string.split("-")    
    return "".join([head.lower()] + [x.title() for x in tail])

def dots_to_camel_case(string):
    names = string.split(".")
    return "".join([names[0]] + [x.title() for x in names[1:]])
    
def dictionary_from_xml(path):
    
    tree = elementTree.parse(path)
    root = tree.getroot()
    
    pairs = [(x.attrib["glyph-name"], x.attrib["unicode"]) for x in root.findall(".//{*}glyph")]
    
    return { k: v for (k, v) in pairs }

def iconsFolderPath():
  if len(sys.argv) > 1:
    folder = pathlib.Path(sys.argv[1])
    assert folder.exists(), f'Path {folder} does not exist'
    return folder
  else:
    # Find source files folder
    iosRootPath = pathlib.Path(__file__).absolute().parent.parent.parent
    return next(iosRootPath.rglob(icons_filename)).parent

if __name__ == "__main__":
    
    icons_folder = iconsFolderPath()
    icons_swift_path = icons_folder.joinpath(icons_filename)
    icon_font_path = icons_folder.joinpath("Icons.ttf")
    
    zip_name = "font.zip"
    unzipped_folder_name = "orbit-icons-font"
    urllib.request.urlretrieve("https://unpkg.com/@kiwicom/orbit-components@latest/orbit-icons-font.zip", zip_name)
    shutil.unpack_archive(zip_name, ".")    
    
    shutil.copyfile(f"{unzipped_folder_name}/orbit-icons.ttf", icon_font_path)    
    icon_values = dictionary_from_xml(f"{unzipped_folder_name}/orbit-icons.svg")
    
    os.remove(zip_name)
    shutil.rmtree(unzipped_folder_name)

    case_lines = []
    value_lines = []

    for icon_name, value in sorted(icon_values.items(), key = lambda x: x[0].lower()):
        
        swift_icon_name = kebab_case_to_camel_case(icon_name)
        
        encoded_value = value.encode("unicode_escape")
        
        if "\\u" in str(encoded_value):
            inner_value = str(encoded_value).split("'")[1].split("u")[-1]            
        else:
            inner_value = hex(ord(value))[2:].zfill(4)
        
        swift_value = f"\\u{{{inner_value}}}"
        
        swift_icon_key = dots_to_camel_case(swift_icon_name)
        case_lines.append(f"        /// Orbit `{swift_icon_name}` icon symbol.\n        case {swift_icon_key}")
        value_lines.append(f"                case .{swift_icon_key}: return \"{swift_value}\"")
            
    updated_file_content = source_template.format(cases = '\n'.join(case_lines), values = '\n'.join(value_lines))
    
    with open(icons_swift_path, "w+") as source_file:
        source_file.write(updated_file_content)
        
