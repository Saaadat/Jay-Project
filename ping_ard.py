import httplib, os, base64
import hashlib, ConfigParser, sys
import socket
import datetime

path = os.path.dirname(os.path.realpath(__file__))
host1 = '172.16.5.153'
host2 = '172.16.4.109'
host3 = '172.16.5.23'
host4 = '172.16.5.69'
uri_path = '/trigger'

#parser initialization 
cfg = ConfigParser.ConfigParser()
cfg.read('%s/touchless.ini' % path)

def send_command(host, uri, timeout, tries):

    secretWord = "TouchlessIsTheGoal"
    #encryption
    hashvalue = hashlib.md5(secretWord).hexdigest()
    headers = {'Authorization': base64.standard_b64encode(hashvalue)}
    try:
       conn = httplib.HTTPConnection(host, timeout=timeout)
       # Send the JSON data as-is -- we don't need to URL Encode this
       r = conn.request("GET", uri, headers=headers)
       response = conn.getresponse()

       print response.status, response.reason

    except (httplib.HTTPException,socket.error):
       print "could not open"
       if tries != 0:
          print "try again"
          with open('wirelessLog.txt', 'a') as the_file:
               the_file.write('Action type = try again || time = '+str(datetime.datetime.now())+'\n')
          send_command(host, uri, 5, tries-1)
       else:
          print "error! check the network"
          with open('wirelessLog.txt', 'a') as the_file:
               the_file.write('Action type = network error || time = '+str(datetime.datetime.now())+'\n')
          pass
    finally:
       conn.close()


if __name__ == '__main__':
     gate_id = "1"
     timeout = 3
     tries = 1
     if gate_id == "1":
         for i in range(1,100):
            send_command(host1, uri_path, timeout, tries)
     if gate_id == "2":
        send_command(host2, uri_path, timeout, tries)
