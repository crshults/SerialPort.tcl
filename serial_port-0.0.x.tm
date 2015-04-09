package provide serial_port 0.0.3

package require TclOO
package require registry
package require list_tools

oo::class create serial_port {
    variable _port_name _port _baud_rate _parity _data_bits _system_serial_ports

    constructor {baud_rate parity {data_bits 8}} {
        set _baud_rate $baud_rate
        set _parity $parity
        set _data_bits $data_bits
        set _system_serial_ports [my AvailableSerialPortList]
        my open
    }

    destructor {
        my close
    }

    method open {} {
        my close
        set _port_name [my GetNextSerialPort]
        catch {set _port [open $_port_name r+]}
        catch {chan configure $_port       \
            -blocking 0                    \
            -buffering none                \
            -encoding binary               \
            -translation {binary binary}   \
            -mode $_baud_rate,$_parity,$_data_bits,1 \
            -pollinterval 1}
        return
    }

    method close {} {
        catch {chan close $_port}
        set _port ""
        return
    }

    method send {message} {
        catch {chan puts -nonewline $_port $message}
        return
    }

    method read {} {
        if {[catch {set response [chan read $_port]}]} {
            return
        } else {
            return $response
        }
    }

    method port_name {} {
        return $_port_name
    }
    
    method parity {new_setting} {
        set _parity $new_setting
        catch {chan configure $_port -mode $_baud_rate,$_parity,8,1}
        return
    }

    method AvailableSerialPortList {} {
        set SerialCommKey {HKEY_LOCAL_MACHINE\Hardware\DeviceMap\SerialComm}
        set port_list {}
        catch {
        foreach port [registry values $SerialCommKey] {
                lappend port_list //./[registry get $SerialCommKey $port]
            }
        }
        return $port_list
    }

    method GetNextSerialPort {} {
        if {[llength [my AvailableSerialPortList]] != [llength $_system_serial_ports]} {
            set _system_serial_ports [my AvailableSerialPortList]
        } else {
            lrotate _system_serial_ports
        }
        return [lindex $_system_serial_ports 0]
    }
}
