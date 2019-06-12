#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import json
import os

def generateDbCmds(device_number, port, reg_map):
    serial_port_cmds = """drvAsynSerialPortConfigure "$(COM{port_nr})", "/dev/{port}"
asynOctetSetInputEos ("$(COM{port_nr})",0,"\\r\\n")
asynOctetSetOutputEos ("$(COM{port_nr})",0,"\\r\\n")
asynSetOption ("$(COM{port_nr})", 0, "baud", "230400")
asynSetOption ("$(COM{port_nr})", 0, "bits", "8")
asynSetOption ("$(COM{port_nr})", 0, "parity", "none")
asynSetOption ("$(COM{port_nr})", 0, "stop", "1")\n"""
    return_str = serial_port_cmds.format(port_nr = device_number, port = port)
    
    return_str += "\n"
    
    db_template = """dbLoadRecords("{db_file}", "SYS=$(SYS), DEV=$(DEV{device_nr}), COM=$(COM{device_nr}), {extra_fields}PRO=ics-dg.proto")\n"""
    
    for item in reg_map:
        list_of_keys = [key for key in item]
        list_of_keys.remove("db_file")
        extra_fields = ""
        for key in list_of_keys:
            value = item[key]
            if type(value) == str:
                value = "'{}'".format(value)
            extra_fields += "{key}={value}, ".format(key = key, value = value)
        return_str += db_template.format(db_file = item["db_file"], device_nr = device_number, extra_fields = extra_fields)
    
    return return_str

def main():
    parser = argparse.ArgumentParser(description = "Generate an EPICS *.cmd-file for detector readout system.")
    parser.add_argument("--path", type = str, nargs = 1, help = "Path to directory containing template (\"detint.cmd.template\") and register map (\"register_map.json\").", required = True)
    parser.add_argument("--serial_ports", type = str, nargs = "+", help = "Serial ports used to connect to readout systems. Number from \"COM1\" to \"COMn\".", required = True)
    args = parser.parse_args()
    
    base_path = os.path.abspath(args.path[0])
    if (base_path[-1] != "/"):
        base_path += "/"
    
    json_file = open(base_path + "register_map.json")
    register_map = json.load(json_file)
    
    write_str = ""
    
    for i, port in enumerate(args.serial_ports):
       write_str += generateDbCmds(i + 1, port, register_map) + "\n"*2
    
    template_file = open(base_path + "detint.cmd.template", "r")
    template_string = template_file.read()
    
    out_file = open(base_path + "detint.cmd", "w")
    
    out_file.write(write_str)
    out_file.write(template_string)
    out_file.close()
    
    

if __name__ == "__main__":
    main()
