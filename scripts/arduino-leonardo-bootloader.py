#!/opt/venv/python3/bin/python3

import time
import serial
import serial.tools.list_ports

def list_usb_cdc_devices():
  ports = serial.tools.list_ports.comports()
  devices = []

  for port in ports:
    device_info = {
      'Port': port.device,
      'VID': f"{port.vid:04x}" if port.vid else "N/A",
      'PID': f"{port.pid:04x}" if port.pid else "N/A"
    }
    devices.append(device_info)

  return devices

if __name__ == "__main__":
  cdc_vid_pid = [
    "2341:8036",
    "03EB:2044"
  ]
  
  devices = list_usb_cdc_devices()
  for device in devices:
    vid_pid = f"{device['VID']}:{device['PID']}".upper()
    if vid_pid in cdc_vid_pid:
      cdc_device = serial.Serial(device['Port'], 1200)
      cdc_device.close()
      break

  for _ in range(10):
    devices = list_usb_cdc_devices()
    for device in devices:
      vid_pid = f"{device['VID']}:{device['PID']}".upper()
      if vid_pid == "2341:0036":
        print(device["Port"])
        exit(0)
    time.sleep(1)
