const db = require('./backend/config/db');

async function checkData() {
    try {
        const [groups] = await db.execute('SELECT * FROM Ride_Groups');
        console.log('--- Ride_Groups ---');
        console.table(groups);
        
        const [members] = await db.execute('SELECT * FROM Group_Members');
        console.log('--- Group_Members ---');
        console.table(members);
        
        const [requests] = await db.execute('SELECT * FROM Ride_Requests');
        console.log('--- Ride_Requests ---');
        console.table(requests);
        
    } catch (err) {
        console.error('Check failed:', err);
    } finally {
        process.exit();
    }
}

checkData();
