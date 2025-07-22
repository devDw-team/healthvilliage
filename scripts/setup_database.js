const fs = require('fs');
const path = require('path');

// Supabase configuration
const SUPABASE_URL = 'https://gcznkwmcjrecupdmtwfu.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdjem5rd21janJlY3VwZG10d2Z1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMwODAzMDEsImV4cCI6MjA2ODY1NjMwMX0.-1D-b2TgtDWOBotKkxkCN2CQG2B-TeVa2aV14Wa3_kU';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY;

async function executeSQLFile(filePath, description) {
    console.log(`\n📄 ${description}`);
    
    try {
        const sql = fs.readFileSync(filePath, 'utf8');
        
        // Use fetch API to execute SQL via Supabase REST API
        const response = await fetch(`${SUPABASE_URL}/rest/v1/rpc/exec_sql`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_ANON_KEY,
                'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
            },
            body: JSON.stringify({ query: sql })
        });

        if (!response.ok) {
            // Try alternative approach - direct POST to SQL endpoint
            const altResponse = await fetch(`${SUPABASE_URL}/sql`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'apikey': SUPABASE_ANON_KEY,
                    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
                },
                body: JSON.stringify({ sql })
            });
            
            if (!altResponse.ok) {
                console.log(`❌ Failed: ${response.status} - ${response.statusText}`);
                return false;
            }
        }
        
        console.log(`✅ Success: ${description}`);
        return true;
    } catch (error) {
        console.error(`❌ Error: ${error.message}`);
        return false;
    }
}

async function setupDatabase() {
    console.log('🚀 Starting database setup...\n');
    
    const migrations = [
        { file: '../supabase/migrations/001_create_extensions.sql', desc: 'Creating extensions' },
        { file: '../supabase/migrations/002_create_users_table.sql', desc: 'Creating users table' },
        { file: '../supabase/migrations/003_create_medical_tables.sql', desc: 'Creating medical tables' },
        { file: '../supabase/migrations/004_create_user_relations.sql', desc: 'Creating user relations' },
        { file: '../supabase/migrations/005_create_functions.sql', desc: 'Creating functions' },
        { file: '../supabase/migrations/006_rls_policies.sql', desc: 'Applying RLS policies' }
    ];
    
    for (const migration of migrations) {
        const filePath = path.join(__dirname, migration.file);
        await executeSQLFile(filePath, migration.desc);
        // Add delay between executions
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    console.log('\n✨ Database setup complete!');
    console.log('\n📝 Next steps:');
    console.log('1. Go to Supabase Dashboard to verify tables');
    console.log('2. Run the Flutter app and test authentication');
}

// Check if we have Node.js fetch or need to import it
if (typeof fetch === 'undefined') {
    console.log('⚠️  This script requires Node.js 18+ or install node-fetch');
    console.log('Run: npm install node-fetch');
    process.exit(1);
}

setupDatabase().catch(console.error);