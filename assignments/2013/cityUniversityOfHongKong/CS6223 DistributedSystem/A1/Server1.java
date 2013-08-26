import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;

public class Server1 extends UnicastRemoteObject implements SampleServer {

/* --------------------- INITIALIZING VARIABLES ----------------------*/
    // variables here must consistent with dispatcher's variables
    private static String ServerName = "SERVER1";
    private static int arrayIndexStart = 100;
    private static int arrayIndexEnd = 199;

    // a hash table to keep key-value pairs of <objectID> and <value>
    public static Map<Integer, DataRecord> newmap = new HashMap<Integer, DataRecord>();
    Server1() throws RemoteException{
	super();
    }

/* --------------------- HELPER FUNCTIONS ---------------------------*/
    // write data
    public boolean write(int tranId, int objectId, int value) throws RemoteException{
	DataRecord dr = (DataRecord) newmap.get(objectId);

	dr.op_write(value);
	System.out.println("trans [" + tranId + "] | key_id = " + objectId + " writes : " + value);
	return true;
    }

    // read data
    public int read(int tranId, int objectId) throws RemoteException{	
	DataRecord dr = (DataRecord) newmap.get(objectId);

	int result = dr.op_read();
	System.out.println("trans [" + tranId + "] | key_id = " + objectId + " reads : " + result);

	return result;
    }

/*----------------------------------------------------------------*/

    // main
    public static void main(String argv[]){
	try{
	    // setting the security manager
//	    System.setSecurityManager(new RMISecurityManager());

	    Server1 Server = new Server1();

	    // initialize storage for hashmap (set all objects' value to 0)
	    for(int i=arrayIndexStart; i<=arrayIndexEnd; i++){
		DataRecord data = new DataRecord(i,0);
	    	newmap.put(i, data);
	    }

	    // binding server's name
	    System.out.println(ServerName);
	    Naming.rebind(ServerName, Server);

	    System.out.println(ServerName + " waiting.....");

	}catch (java.net.MalformedURLException me){
	    System.out.println("Malformed URL: " + me.toString());

	}catch (RemoteException re){
	    System.out.println("Remote exception: " + re.toString());

	}
    }
}
