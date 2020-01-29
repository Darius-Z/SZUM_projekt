# Sprawozdanie Projekt robot iCub

Zawarty skrypt utworzony w środowisku *Matlab* pozwala na sterowanie robotem *iCub* w tym przypadku symulowanym w środowisku *iCub_sim*.
Komunikacja odbywa się dzięki połączeniu się z IP robota poprzez serwer *yarp* przy wykorzystaniu techniki komunikacji *tcp*.

Oczywiście musimy mieć zainstalowane całe wspomniane oprogramowanie - *Matlab*, *iCub_sim* oraz *yarp*.

Aby uruchomić serwer *yarp* należy w systemowym oknie komend wpisać: 

```sh
yarpserver
```

Odpowiedni komunikat wskaże nam, czy połączenie przebiegło prawidłowo.
W następnej kolejności włączamy środowisko *iCub_sim* i uruchamiamy symulację.

Włączamy *Matlab* oraz przygotowujemy nasz skrypt sterujący, czyli plik `icub.m`. 

Aby zmienić orientację oczu robota zmieniamy wedle uznania wartości przypisane do zmiennych:

```sh
theta1_oczy
theta2_oczy
```

Aby zmienić orientację głowy robota zmieniamy wedle uznania wartości przypisane do zmiennych:

```sh
theta1_glowa_stopnie
theta2_glowa_stopnie
theta3_glowa_stopnie
```

Wartości `1` `2` `3` w powyższych linijkach oznaczają odpowiednie stopnie swobody danego członu robota (głowa/oczy).

Po wpisaniu żądanych wartości uruchamiamy nasz skrypt funkcją `Run` i obserwujemy efekt na symulatorze.

**Powodzenia!**