const db = require('./backend/config/db');

async function seedUtilityData() {
    try {
        console.log('Seeding Dummy Data for John (UserID 1)...');
        
        // 1. Add Favorite Routes
        await db.execute('INSERT INTO Saved_Locations (UserID, Name, LocationID) VALUES (1, ?, ?)', ['Home', 1]);
        await db.execute('INSERT INTO Saved_Locations (UserID, Name, LocationID) VALUES (1, ?, ?)', ['University', 5]);
        await db.execute('INSERT INTO Saved_Locations (UserID, Name, LocationID) VALUES (1, ?, ?)', ['Office', 11]);
        console.log('✅ Added Favorite Routes.');

        // 2. Add Emergency Contacts
        await db.execute('INSERT INTO Emergency_Contacts (UserID, ContactName, PhoneNumber, Relation) VALUES (1, ?, ?, ?)', ['Ali Khan', '+92 300 1234567', 'Brother']);
        await db.execute('INSERT INTO Emergency_Contacts (UserID, ContactName, PhoneNumber, Relation) VALUES (1, ?, ?, ?)', ['Sana Ahmed', '+92 321 7654321', 'Mother']);
        console.log('✅ Added Emergency Contacts.');

        // 3. Update Wallet Balance (Ensuring it's visible)
        await db.execute('UPDATE Users SET WalletBalance = 7500.00 WHERE UserID = 1');
        console.log('✅ Updated Wallet Balance.');

    } catch (err) {
        console.error('Seeding failed:', err);
    } finally {
        process.exit();
    }
}

seedUtilityData();
