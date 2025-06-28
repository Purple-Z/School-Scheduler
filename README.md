# School Scheduler

**School Scheduler** è un progetto open source per gestire le attività e le risorse di un istituto scolastico. Il repository contiene due componenti principali:

- **server**: backend sviluppato in Python con Flask e database MySQL. Gestisce utenti, ruoli, disponibilità delle risorse e invio di notifiche via email.
- **client**: applicazione Flutter che fornisce l'interfaccia utente per dispositivi mobili e Web.

## Caratteristiche principali

- **Gestione di utenti, ruoli e risorse scolastiche**<br>
Ogni utente può avere più ruoli. Ogni ruolo ha 28 permessi. Ogni permesso abilita ad un servizio dell'applicazione. Posso creare dinamicamente i ruoli all'interno della mia applicazione. Se ha i permessi un utente può creare una risorsa definendone il tipo, il luogo, l'attività ed eventuali referenti. Per ogni risorsa posso anche impostare dei parametri: auto-accept delle prenotazioni, over-booking e gestione in slot. Questi parametri servono per una gestione ottimale delle risorse.<br>

- **Prenotazione e pianificazione con promemoria via email**<br>
È possibile penotare una determinata risorsa per un certo periodo e si verrà notificati tramite mail della prenotazione effettuata.<br>

- **Previsioni sull'utilizzo delle risorse**<br>
Si una un algoritmo di regressione polinomiale (Machine Learning) per predirre quante risorse saranno prenotare ad una certa ora.<br>

- **Supporto multilingua (italiano e inglese)**<br>
L'intera applicazione è tradotta in italiano ed inglese. È anche disponibile la modalità scura/chiara.

## Pagine principali

| | |
|---|---|
| <img src="images/Screenshot_20250628_105059.jpg" width="250"/> | <img src="images/Screenshot_20250628_105110.jpg" width="250"/> |
| Pagina account.| Visualizzazione risorse prenotabili.|
| <img src="images/Screenshot_20250628_105123.jpg" width="250"/> | <img src="images/Screenshot_20250628_105151.jpg" width="250"/> |
| Pagina di gestione.| Calendario interattivo<br>delle prenotazioni.|
| <img src="images/Screenshot_20250628_105416.jpg" width="250"/> | <img src="images/Screenshot_20250628_105433.jpg" width="250"/> |
| Pagine per le prenotazioni 1.| Pagina per le prenotazioni 2.|

## Requisiti

- Python 3.12 o superiore
- MySQL
- Flutter SDK

## Installazione

1. Clona il repository:
   ```bash
   git clone <url del repository>
   cd School-Scheduler
   ```
2. **Server**
   ```bash
   cd server
   python3 -m venv .venv
   source .venv/bin/activate
   pip install flask mysql-connector-python bcrypt pytz matplotlib
   python app.py
   ```
3. **Client**
   ```bash
   cd client
   flutter pub get
   flutter run
   ```

## Struttura del progetto

```
School-Scheduler/
├─ client/  # applicazione Flutter
|   └─ lib/ # contenuto applicazione
|       └─ pages/ # codice delle pagine dell'applicazione
└─ server/  # backend Flask
```

## Come contribuire

1. Effettua il fork del repository e crea un branch per le tue modifiche.
2. Implementa il cambiamento seguendo le linee guida del progetto.
3. Invia una pull request descrivendo il tuo contributo.
