import java.rmi.*;

public interface SampleServer extends Remote {

    public boolean write(int tranId, int objectId, int value) throws RemoteException;
    public int read(int tranId, int objectId) throws RemoteException;
}
