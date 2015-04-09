# SerialPort.tcl
**Problem:**
I wanted a simpler interface to my serial ports that would allow me to just walk through ports as I try to determine
1. is there a device attached to this port? and,
2. what device is it?

**Example:**

```
package require serial_port
serial_port create myDevice 9600 n
myDevice send \x01\xff\x55\xaa
set data [myDevice read]
```

Now, if the private methods [AvailableSerialPortList] and [GetNextSerialPort] were callable by you, here's what they might do:

```
AvailableSerialPortList; # -> //./COM1 //./COM7 //./COM8
GetNextSerialPort; # -> //./COM7
GetNextSerialPort; # -> //./COM8
GetNextSerialPort; # -> //./COM1
GetNextSerialPort; # -> //./COM7
```

**The Rest of the Interface:**

`open`: Opens the next available port from the list

`close`: Closes the currently open port

`send`: Sends data out onto the serial port

`read`: Reads data from the serial port

`port_name`: Returns the name of the port that is currently open

`parity`: Allows you to change the parity setting of your open port

## How to make it available for use:

1. Take the Tcl module file and drop it into `<TclInstallRoot>\lib\tcl8\8.6\`
2. Rename it to serial_port-0.0.3.tm
3. `package require serial_port`
