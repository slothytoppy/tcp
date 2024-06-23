package server

import "core:fmt"
import "core:net"
import "core:os"
import "core:strings"
import "core:sys/linux"
import "core:sys/unix"

send_message :: proc(socket: net.TCP_Socket, message: string) {
	fd, err := linux.fcntl_getfd(linux.Fd(socket), .GETFD)
	if (err != .NONE) {
		fmt.panicf("invalid socket")
	}
	net.send_tcp(socket, transmute([]byte)message)
}

main :: proc() {
	socket, err := net.create_socket(.IP4, .TCP)
	if err != nil {
		fmt.panicf("failed to create tcp socket")
	}
	endpoint: net.Endpoint
	endpoint.port = 5566
	ok: bool = true
	if endpoint.address, ok = net.aton("127.0.0.1", .IP4, true); !ok {
		fmt.panicf("failed to connect to address 127.0.1")
	}
	tcp_socket: net.TCP_Socket
	tcp_socket, err = net.dial_tcp_from_endpoint(endpoint)
	defer net.close(tcp_socket)
	num_sent: int
	if err != nil {
		fmt.println("client error:", err)
	}
	for {
		send_message(tcp_socket, "2:hello:14:from_hello")
		unix.sleep(1)
	}
}
