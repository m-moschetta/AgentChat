# Piano di Integrazione N8N - AgentChat

## Obiettivo

Integrare n8n come provider AI per permettere l'esecuzione di workflow personalizzati attraverso l'interfaccia di AgentChat.

## Componenti Implementati

### 1. N8NService
- **Endpoint**: Configurabile per istanze n8n personalizzate
- **Autenticazione**: Supporto per API key
- **Esecuzione Workflow**: Invio di messaggi e ricezione risposte
- **Gestione Errori**: Handling specifico per errori n8n

### 2. N8NWorkflow Model
- **ID Workflow**: Identificatore univoco del workflow
- **Nome**: Nome descrittivo del workflow
- **Descrizione**: Descrizione delle funzionalità
- **Parametri**: Parametri configurabili del workflow

### 3. N8NWorkflowManager
- **Gestione Workflow**: CRUD operations per i workflow
- **Persistenza**: Salvataggio locale dei workflow configurati
- **Validazione**: Controlli sui parametri dei workflow

### 4. AddN8NWorkflowView
- **Interfaccia Utente**: Form per aggiungere nuovi workflow
- **Configurazione Parametri**: UI per definire i parametri
- **Test Workflow**: Possibilità di testare i workflow

## Flusso di Integrazione

### 1. Configurazione Iniziale
1. L'utente configura l'endpoint n8n nelle impostazioni
2. Inserisce l'API key per l'autenticazione
3. Testa la connessione al server n8n

### 2. Aggiunta Workflow
1. L'utente naviga alla sezione "Aggiungi Workflow N8N"
2. Inserisce ID, nome e descrizione del workflow
3. Configura i parametri necessari
4. Salva il workflow nella configurazione locale

### 3. Utilizzo in Chat
1. L'utente seleziona un workflow n8n come provider
2. Invia un messaggio che viene processato dal workflow
3. Il workflow restituisce una risposta elaborata
4. La risposta viene visualizzata nella chat

## Struttura dei Dati

### Configurazione N8N
```swift
struct N8NConfiguration {
    let baseURL: String
    let apiKey: String
    let workflows: [N8NWorkflow]
}
```

### Workflow N8N
```swift
struct N8NWorkflow {
    let id: String
    let name: String
    let description: String
    let parameters: [WorkflowParameter]
}
```

### Parametro Workflow
```swift
struct WorkflowParameter {
    let name: String
    let type: ParameterType
    let required: Bool
    let defaultValue: String?
}
```

## API Integration

### Endpoint Principali
- `POST /webhook/{workflowId}`: Esecuzione workflow
- `GET /workflows`: Lista workflow disponibili
- `GET /workflow/{id}`: Dettagli workflow specifico

### Formato Richiesta
```json
{
    "message": "Testo del messaggio utente",
    "parameters": {
        "param1": "valore1",
        "param2": "valore2"
    }
}
```

### Formato Risposta
```json
{
    "response": "Risposta elaborata dal workflow",
    "status": "success",
    "metadata": {
        "executionTime": 1234,
        "workflowId": "workflow-123"
    }
}
```

## Gestione Errori

### Tipi di Errore
1. **Connessione**: Problemi di rete o endpoint non raggiungibile
2. **Autenticazione**: API key non valida o scaduta
3. **Workflow**: Workflow non trovato o parametri non validi
4. **Esecuzione**: Errori durante l'esecuzione del workflow

### Strategie di Recovery
- **Retry**: Tentativi multipli per errori temporanei
- **Fallback**: Utilizzo di provider alternativi
- **User Notification**: Notifica all'utente per errori persistenti

## Sicurezza

### Autenticazione
- API key memorizzate nel Keychain
- Validazione delle credenziali ad ogni richiesta
- Timeout configurabili per le richieste

### Validazione Input
- Sanitizzazione dei parametri utente
- Controlli sui tipi di dato
- Limitazioni sulla lunghezza dei messaggi

## Testing

### Unit Tests
- Test dei servizi N8N
- Validazione dei modelli
- Gestione errori

### Integration Tests
- Test con istanza n8n di sviluppo
- Verifica dei workflow di esempio
- Test delle performance

## Roadmap

### Fase 1 (Completata)
- [x] Implementazione N8NService base
- [x] Modelli per workflow e parametri
- [x] Interfaccia utente per configurazione

### Fase 2 (In Corso)
- [ ] Miglioramento gestione errori
- [ ] Ottimizzazione performance
- [ ] Test di integrazione completi

### Fase 3 (Pianificata)
- [ ] Workflow templates predefiniti
- [ ] Monitoring e analytics
- [ ] Documentazione utente completa