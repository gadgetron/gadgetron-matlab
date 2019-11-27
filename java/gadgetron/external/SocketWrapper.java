
package gadgetron.external;

import java.net.Socket;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class SocketWrapper {

    private Socket socket;
    private InputStream input;
    private OutputStream output;

    public SocketWrapper(Socket socket) throws IOException {
        this.socket = socket;
        this.input = socket.getInputStream();
        this.output = socket.getOutputStream();
    }

    public byte[] read(int n) throws IOException
    {
        byte[] buffer = new byte[n];
        int read = 0;
        while (read != n) {
            read += input.read(buffer, read, n - read);
        }
        return buffer;
    }
    
    public void write(byte[] bytes) throws IOException { output.write(bytes); }
    public void close() throws IOException { socket.close(); }
}