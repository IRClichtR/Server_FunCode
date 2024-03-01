#include <sys/socket.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

int main(void) {

  // Declare socket address and server addres struct 
  struct sockaddr_in serverAddr;

  // create socket ______// 
  int server_socket = socket(AF_INET,SOCK_STREAM, 0);
  if (server_socket <0) {
    perror("Error creating socket");
    exit(EXIT_FAILURE);
  }

  int server_port = 12545;

  serverAddr.sin_family = AF_INET;
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1"); //change to INADDR_ANY to turn it to the web;
  serverAddr.sin_port = htons(server_port);

  // bind socket to all disponible interfaces
  if (bind(server_socket,(struct sockaddr *)&serverAddr,sizeof(serverAddr)) <0) {
    perror("Error binding socket");
    exit(EXIT_FAILURE);
  }

  int res = listen(server_socket, 5);
  if (res < 0) {
    perror("You suck");
  }
  else
    printf("Listening on port %d\n", server_port);

  struct sockaddr_in clientAddr;
  socklen_t clientAddreLen;
  int client_socket;
  char buffer[BUFFER_SIZE];

  while (1) {

    clientAddreLen = sizeof(clientAddr); 
    client_socket = accept(server_socket, (struct sockaddr *)&clientAddr, &clientAddreLen);
    if (client_socket < 0) {
      perror("Error accepting connection");
      continue;
    }
    int bytes_received = recv(client_socket,buffer,BUFFER_SIZE,0);
    if (bytes_received < 0) {
      perror("Error receiving data");
      close(client_socket);
      continue;
    }
    printf("Received request from %s:%d:\n%s\n", inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port), buffer);

    const char *response = "HTTP/1.1 200 OK\r\n\r\nI'm an awsome server. Come kiss me";
    int bytes_sent = send(client_socket, response, strlen(response),0);
    if (bytes_sent < 0) {
      perror("Error sending data");
      close(client_socket);
      continue;
    }
    printf("Sent 'Hello world' response to %s:%d\n", inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port));
    close(client_socket);
  }

  close(server_socket);

  return (0);
}

