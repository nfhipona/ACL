import mysql, { Pool, PoolConnection } from 'mysql';

export interface DatabaseConfig {
    connectionLimit: number,
    host: string,
    user: string,
    password: string,
    database: string
}

export default function (DatabaseSettings: DatabaseConfig) {
    const pool: Pool = mysql.createPool(DatabaseSettings);

    const connection = async (): Promise<PoolConnection> => {
        return new Promise((resolve, reject) => {
            pool.getConnection((err, conn) => {
                if (err) return reject(err);
                resolve(conn);
            });
        });
    }

    const transaction = async (): Promise<PoolConnection> => {
        return new Promise((resolve, reject) => {
            pool.getConnection((err, conn) => {
                if (err) return reject(err);
                conn.beginTransaction(err => {
                    if (err) return reject(err);
                    resolve(conn);
                })
            });
        });
    }

    const rollback = async (conn: PoolConnection): Promise<void> => {
        return new Promise((resolve, _) => {
            conn.rollback(() => {
                conn.destroy();
                resolve();
            });
        });
    }

    const commit = async (conn: PoolConnection): Promise<void> => {
        return new Promise((resolve, reject) => {
            conn.commit(err => {
                if (err) {
                    rollback(conn)
                        .then(() => {
                            reject(err);
                        });
                } else {
                    conn.destroy();
                    resolve();
                }
            });
        });
    }

    return {
        pool,
        connection,
        transaction,
        rollback,
        commit
    }
}