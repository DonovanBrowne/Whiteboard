// websocketServer.ts
import { WebSocketServer, WebSocket } from 'ws';
import { createServer } from 'http';

let whiteboardState: any[] = [];
let wss: WebSocketServer;

// Initialize WebSocket server
const initWebSocketServer = () => {
    const server = createServer();
    wss = new WebSocketServer({ server });

    // Handle WebSocket connections
    wss.on('connection', (ws) => {
        console.log('New WebSocket connection established');
        
        // Send the current state to the new client
        ws.send(JSON.stringify(whiteboardState));

        ws.on('message', (message: string) => {
            // Update whiteboard state
            const update = JSON.parse(message.toString());
            whiteboardState.push(update);
            
            // Broadcast to all clients
            wss.clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(message.toString());
                }
            });
        });

        ws.on('error', (error) => {
            console.error('WebSocket error:', error);
        });

        ws.on('close', () => {
            console.log('Client disconnected');
        });
    });

    // Start server on port 3000
    server.listen(3000, () => {
        console.log('WebSocket server is running on port 3000');
    });

    return wss;
};

export { initWebSocketServer };