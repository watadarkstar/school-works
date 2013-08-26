
// DataRecord class

public class DataRecord {
    private final int IDLE_MODE = 0;		// idle mode
    private final int READ_MODE = 1;		// read mode
    private final int WRITE_MODE = 2;   	// write mode
    private final int READ_TIME = 4000; 	// read process time
    private final int WRITE_TIME = 10000;	// write process time

    private int state;
    private int key_id;
    private int value;

    // constructor
    public DataRecord(int i_keyId, int i_value){
	key_id = i_keyId;
	value = i_value;
	state = IDLE_MODE;
    }

    public synchronized int op_read(){
	int out_value;

	while (state != IDLE_MODE){
	    try{
		wait();
	    }catch (InterruptedException e){
		System.out.println("Error in op_read(wait()) in DataRecord.java");
	    }
	}

	state = READ_MODE;

	try{
	    Thread.sleep(READ_TIME);
	}catch (InterruptedException e){
	    System.out.println("Error in op_read(Thread.sleep() in DataRecord.java");
	}

	out_value = value; 
	state = IDLE_MODE;
	notifyAll();

	return out_value;
    }

    public synchronized void op_write(int i_value){
	while(state != IDLE_MODE){
	    try{
		wait();
	    }catch (InterruptedException e){
		System.out.println("Error in op_write(wait()) in DataRecord.java");
	    }
	}
	state = WRITE_MODE;
	try{
	    Thread.sleep(WRITE_TIME);
	}catch (InterruptedException e){
	    System.out.println("Error in op_write(Thread.sleep() in DataRecord.java");
	}
	value = i_value;
	state = IDLE_MODE;
	notifyAll();
    }
	
    public int getId(){
	return key_id;
    }
}
