#include "router.h"
#include <stdio.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <vector>
#include <string>
#include <stdlib.h>
#include <algorithm>
#include <iostream>
#include <fstream>

using namespace std;

// structure for shortest path
struct SP {
    unsigned int routerId;	// router id
    unsigned int cost;		// cost so far to take from source to this router
    unsigned int bestRouter;	// the best router to send packet to routerId 
    bool expanded;		// check if the node has expanded
    unsigned int nb;		// neighbour router to choose
};

// structure for topology database
struct DB {
    unsigned int routerId;		// router id
    vector<struct link_cost> link_id;	// links id corresponds to the router
};

// GLOBAL VARIABLES
int routerId;		// id of the router
char *nseHost;		// address of the NSE
int nsePort;		// port of the NSE
int routerPort;		// port of the router
vector<struct pkt_LSPDU> save; // save all the pkt_LSPDU that the router received
vector<struct SP> RIB;	// routing information base
vector<int> routers;	// keep a list of router
vector<struct pkt_LSPDU> pathsExpanded; // keep a list of expanded paths
string filename;	// name of the file
string nickname;	// name of the router
vector<struct DB> TDB;	// topology database

// DUMP ERRORS
void diep(string s){
    const char* c_str = s.c_str();
    perror(c_str);
    exit(1);
}

// just for sorting purposes
bool sortDB(struct DB a, struct DB b){
    if(a.routerId < b.routerId){
	return true;
    }
    return false;
}
bool sortRIB(struct SP a, struct SP b){
    if(a.routerId < b.routerId){
	return true;
    }
    return false;
}

// Add new entry to DB
// need to check if duplicated LS PDU
bool newEntryToDB(struct pkt_LSPDU lspdu){
    for(unsigned int i = 0; i<save.size(); i++){
	if(lspdu.sender == save[i].sender &&
	   lspdu.router_id == save[i].router_id &&
	   lspdu.link_id == save[i].link_id &&
	   lspdu.cost == save[i].cost &&
	   lspdu.via == save[i].via){
	    return false;
	}
    }
    save.push_back(lspdu);
    return true;
}

// sub-routine for shortest path algorithm
// to find all links coressponds to this router
vector<struct pkt_LSPDU> find_all_edges(int id, vector<struct pkt_LSPDU> ep){
    vector<struct pkt_LSPDU> temp;
    for(unsigned int i = 0 ; i<save.size(); i++){
	if(save[i].router_id == id){
	    bool used = false;
	    for(unsigned int j = 0; j<ep.size(); j++){
		if(save[i].link_id == ep[j].link_id){
		    used = true;
		}
	    }
	    if(!used){
		temp.push_back(save[i]);
	    }
	}
    }
    return temp;
}

// sub-routine for shortest path algorithm
// to find out what is the router id for the other end of the link
int find_other_end(struct pkt_LSPDU ls, int id){
    for(unsigned int i = 0; i<save.size(); i++){
	if((ls.link_id == save[i].link_id) && (id != save[i].router_id)){
	    return save[i].router_id;
	}
    }
}

// sub-routine for shortest path algorithm
// find the best router(lowest cost) to expand
struct SP find_min(vector<struct SP> v){
    struct SP solution;
    int min;
    for(unsigned int i = 0; i<v.size(); i++){
	if(v[i].expanded == false){
	    min = v[i].cost;
	    solution = v[i];
	    break;
	}
    }

    for(unsigned int i = 0; i<v.size(); i++){
	if((min > v[i].cost) && (v[i].expanded == false)){
	    min = v[i].cost;
	    solution = v[i];
	}
    }
    return solution;
}

// sub-routine for shortest path algorithm
// mark the router that has already expanded
vector<struct SP> set_expanded(vector<struct SP> v, struct SP s){
    for(unsigned int i = 0; i<v.size(); i++){
	if(v[i].routerId == s.routerId &&
	   v[i].cost == s.cost &&
	   v[i].bestRouter == s.bestRouter &&
	   v[i].expanded == false){
	    v.erase(v.begin() + i);
	    s.expanded = true;
	    v.push_back(s);
	}
    }
    return v;
}

// sub-routine for shortest path algorithm
// expand and find the neighbours of router
vector<struct SP> expand_node(struct SP node){
    vector<struct SP> temp;
    vector<struct pkt_LSPDU> edges;
    edges = find_all_edges(node.routerId, pathsExpanded);
    for(unsigned int i = 0; i<edges.size(); i++){
	int end = find_other_end(edges[i], edges[i].router_id);
	struct SP sp;
	sp.routerId = end;
	sp.cost = node.cost + edges[i].cost;
	sp.bestRouter = node.routerId;
	sp.expanded = false;
	if(node.routerId == routerId){
	    sp.nb = end;
	}else {
	    sp.nb = node.nb;
	}
	temp.push_back(sp);
    }
    return temp;
}

// sub-routine for shortest path algorithm
// to add a new node into vector
vector<struct SP> add_node(vector<struct SP> v, struct SP s){
    // if found, compare and use the best node
    for(unsigned int i = 0; i<v.size(); i++){
	if(s.routerId == v[i].routerId){
	    if(s.cost < v[i].cost){
		v.erase(v.begin() + i);
		v.push_back(s);
	    }
	    return v;
	}
    }
    // if not found, add it to v
    v.push_back(s);
    return v;
}

// shortest path algorithm
void shortest_path_alg(int source, vector<struct pkt_LSPDU> s){
    // delete previous informations
    routers.clear();
    pathsExpanded.clear();
    RIB.clear();

    // initialize
    vector<struct SP> tree;
    struct SP sp;
    sp.routerId = source;
    sp.cost = 0;
    sp.bestRouter = -1;
    sp.expanded = false;
    sp.nb = source;

    routers.push_back(routerId);
    tree.push_back(sp);

    // expand our tree 
    while(RIB.size() != NBR_ROUTER){
	struct SP minRouter = find_min(tree);
	RIB.push_back(minRouter);
	tree = set_expanded(tree, minRouter);
	vector<struct SP> temp = expand_node(minRouter);
	if(temp.size() == 0){
	    break;
	}
	for(unsigned int i = 0; i<temp.size(); i++){
	    tree = add_node(tree, temp[i]);
	}
	 
    }
}

// Organize the toplogy database, while receiving and new LS PDU update the DB
bool AddTopologyDB(struct pkt_LSPDU v){
    bool RouterCheck = false;

    // check whether router in DB
    for(unsigned int i = 0; i<TDB.size(); i++){
	if(v.router_id == TDB[i].routerId){
	    RouterCheck = true;
	    bool LinkCheck = false;

	    // check whether link already exist
	    for(unsigned int j = 0; j<TDB[i].link_id.size(); j++){
		if(TDB[i].link_id[j].link == v.link_id){
		    LinkCheck = true;
		}
	    }

	    // if not, add it
	    if(!LinkCheck){
		struct link_cost lc;
		lc.link = v.link_id;
		lc.cost = v.cost;
		TDB[i].link_id.push_back(lc);
		return true;
	    }
	    return false;
	}
    }

    // if not, add it
    if(!RouterCheck){
	struct DB temp;
	struct link_cost temp_lc;
	temp.routerId = v.router_id;
	temp_lc.link = v.link_id;
	temp_lc.cost = v.cost;
	temp.link_id.push_back(temp_lc);
	TDB.push_back(temp);
	return true;
    }
    return false;
}	

int main(int argc, char * argv[]){
    struct hostent *host;
    struct sockaddr_in si_me, si_other;
    int sock, retval;
    socklen_t len;
    ofstream myfile;

    // Read input and initialize
    if(argc != 5){
	fprintf(stderr, "Bad Arguments\n");
	exit(1);
    }
    routerId = atoi(argv[1]);
    nseHost = argv[2];
    nsePort = atoi(argv[3]);
    routerPort = atoi(argv[4]);
    filename.append("router");
    filename.append(argv[1]);
    filename.append(".log");
    nickname.append("R");
    nickname.append(argv[1]);
    myfile.open(filename.c_str());

    // find NSE
    host = gethostbyname(nseHost);
    if(host == NULL){
	fprintf(stderr, "ERROR: No such host\n");
	exit(1);
    }

    // Set up the socket
    if((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1){
	diep("Create Socket Failed");
    }

    // server side
    bzero(&si_other, sizeof(si_other));
    memcpy((char *)&si_other.sin_addr, host->h_addr, host->h_length);
    si_other.sin_family = host->h_addrtype;
    si_other.sin_port = htons(nsePort);

    // client side
    bzero(&si_me, sizeof(si_me));
    si_me.sin_family = AF_INET;
    si_me.sin_addr.s_addr = htonl(INADDR_ANY);
    si_me.sin_port = htons(routerPort);

    retval = bind(sock, (struct sockaddr *)&si_me, sizeof(si_me));
    if(retval < 0){
	diep("bind");
    }

    // Send pkt_INIT packet
    struct pkt_INIT init;
    init.router_id = routerId;

    if (sendto(sock, &init, sizeof(struct pkt_INIT), 0, (struct sockaddr *) &si_other, sizeof(si_other)) == -1){
	diep("sendto()");
    }

    // log
    myfile << nickname << " sends an INIT: router_id " << init.router_id << endl;

    // Receive circuit_DB packet
    struct circuit_DB db;
    len = sizeof(si_me);
    if(recvfrom(sock, &db, sizeof(struct circuit_DB), 0, (struct sockaddr *)&si_me, &len) == -1){
	diep("recvfrom()");
    }

    // log
    myfile << nickname << " receives an CIRCUIT_DB: nbr_link " << db.nbr_link <<
 ", link_cost in the following: " << endl;
    for(int i = 0; i<db.nbr_link; i++){
        myfile << "link " << db.linkcost[i].link << ", cost " << db.linkcost[i].
cost << endl;
    }

    // update toplogy DB
    struct DB temp_db;
    temp_db.routerId = routerId;
    for(int i = 0; i<db.nbr_link; i++){
	temp_db.link_id.push_back(db.linkcost[i]);
    }
    TDB.push_back(temp_db);	

    // log
    myfile << "# Topology database" << endl;
    for(unsigned int i = 0; i<TDB.size(); i++){
        myfile << nickname << " -> R" << TDB[i].routerId << " nbr link " << TDB[i].link_id.size() << endl;
        for(unsigned int j = 0; j<TDB[i].link_id.size(); j++){
            myfile << nickname << " -> R" << TDB[i].routerId << " link " << TDB[i].link_id[j].link << " cost " << TDB[i].link_id[j].cost << endl;
        }
    }

 
    // Send pkt_Hello packet to neighbours
    struct pkt_HELLO hello;
    hello.router_id = routerId;
    for(int i = 0; i<db.nbr_link; i++){
	hello.link_id = db.linkcost[i].link;
	if (sendto(sock, &hello, sizeof(struct pkt_HELLO), 0, (struct sockaddr *) & si_other, sizeof(si_other)) == -1){
	    diep("sendto()");
	}

	// log
	myfile << nickname << " sends an HELLO: router_id " << hello.router_id
<< ", link_id " << hello.link_id << endl;

    }

    // let the routers have enough time to receive HELLO, and not mixed up with LSPDU
    sleep(1);

    // Receive pkt_Hello packet from neighbours
    for(int i = 0; i < db.nbr_link; i++){
	struct pkt_HELLO hel;
	retval = (recvfrom(sock, &hel, sizeof(struct pkt_HELLO), 0, (struct sockaddr *)&si_me, &len));
	if(retval == -1){
	    diep("recvfrom()");
	}

	// log
	myfile << nickname << " receives an HELLO: router_id " << hel.router_id
<< ", link_id " << hel.link_id << endl;

	unsigned int linkID = hel.link_id;

	// Reply with LSPDU
	struct pkt_LSPDU lspdu;
	lspdu.sender = routerId;
	lspdu.router_id = routerId;
	for(int j = 0; j < db.nbr_link; j++){
	    lspdu.link_id = db.linkcost[j].link;
	    lspdu.cost = db.linkcost[j].cost;
	    lspdu.via = linkID;
	    if (sendto(sock, &lspdu, sizeof(struct pkt_LSPDU), 0, (struct sockaddr *) & si_other, sizeof(si_other)) == -1){
		diep("sendto()");
	    }

	    // log
	    myfile << nickname << " sends an LS PDU: sender " << lspdu.sender <<
 ", router_id " << lspdu.router_id << ", link_id " << lspdu.link_id << ", cost "
 << lspdu.cost << ", via " << lspdu.via << endl;
	}
    }


    // Receive pkt_LSPDU packet from neighbours
    for(;;){
	int sender;
	bool check, DBCheck;
	struct pkt_LSPDU recv_lspdu;
	retval = (recvfrom(sock, &recv_lspdu, sizeof(struct pkt_LSPDU), 0, (struct sockaddr *)&si_me, &len));
	sender = recv_lspdu.via;
	check = newEntryToDB(recv_lspdu);
	DBCheck = AddTopologyDB(recv_lspdu);

	// log
	myfile << nickname << " receives an LS PDU: sender " << recv_lspdu.sender << ", router_id " << recv_lspdu.router_id << ", link_id " << recv_lspdu.link_id << ", cost " << recv_lspdu.cost << ", via " << recv_lspdu.via << endl;

	if(DBCheck){
	    // log
	    sort(TDB.begin(), TDB.end(), sortDB);
	    myfile << "# Topology database" << endl;
    	    for(unsigned int i = 0; i<TDB.size(); i++){
            myfile << nickname << " -> R" << TDB[i].routerId << " nbr link " << TDB[i].link_id.size() << endl;
        	for(unsigned int j = 0; j<TDB[i].link_id.size(); j++){
        	    myfile << nickname << " -> R" << TDB[i].routerId << " link " << TDB[i].link_id[j].link << " cost " << TDB[i].link_id[j].cost << endl;
        	}
    	    }

	}

	// forward the new/updated pkt_LSPDU to other neighbours
	if(check){
	    for(unsigned int i = 0; i<db.nbr_link; i++){
		if(db.linkcost[i].link != sender){
		    struct pkt_LSPDU send_lspdu;
		    send_lspdu.sender = routerId;
		    send_lspdu.router_id = recv_lspdu.router_id;
		    send_lspdu.link_id = recv_lspdu.link_id;
		    send_lspdu.cost = recv_lspdu.link_id;
		    send_lspdu.via = db.linkcost[i].link;
		    if(sendto(sock, &send_lspdu, sizeof(struct pkt_LSPDU), 0, (struct sockaddr *) & si_other, sizeof(si_other)) == -1){
			diep("sendto()");
		    }

		    // log
		    myfile << nickname << " sends an LS PDU: sender " << send_lspdu.sender << ", router_id " << send_lspdu.router_id << ", link_id " << send_lspdu.link_id << ", cost " << send_lspdu.cost << ", via " << send_lspdu.via << endl;

		}
	    }
	}

	// run shortest path alogithm
	shortest_path_alg(routerId, save);

	// log RIB
	if(check){
	    sort(RIB.begin(), RIB.end(), sortRIB);
	    myfile << "# RIB" << endl;
            for(unsigned int i = 0; i<RIB.size(); i++){
                myfile << nickname << " -> R" << RIB[i].routerId << " -> ";
                int nextR = RIB[i].nb;
                if(nextR == routerId){
                    myfile << "Local, 0" << endl;
                }else if(nextR == -2){
		    myfile << "INF" << endl;
		}else {
                    myfile << "R" << nextR << ", " << RIB[i].cost << endl;
                }
            }
	}
    }

    close(sock);


    return 0;
}
