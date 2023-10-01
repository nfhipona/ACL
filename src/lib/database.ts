import mysql, {
    Pool,
    PoolConnection,
    QueryOptions,
    queryCallback,
    MysqlError,
    FieldInfo
} from 'mysql';
import { Database, DatabaseConfig, Callback } from './interface';

export class MyDatabase implements Database {
    pool: Pool
    constructor(settings: DatabaseConfig) {
        this.pool = mysql.createPool(settings);
    }

    async connection(): Promise<PoolConnection> {
        return new Promise((resolve, reject) => {
            this.pool.getConnection((err, conn) => {
                if (err) return reject(err);
                resolve(conn);
            });
        });
    }

    async transaction(): Promise<PoolConnection> {
        return new Promise((resolve, reject) => {
            this.pool.getConnection((err, conn) => {
                if (err) return reject(err);
                conn.beginTransaction(err => {
                    if (err) return reject(err);
                    resolve(conn);
                })
            });
        });
    }

    async rollback(conn: PoolConnection): Promise<void> {
        return new Promise((resolve, _) => {
            conn.rollback(() => {
                conn.destroy();
                resolve();
            });
        });
    }

    async commit(conn: PoolConnection): Promise<void> {
        return new Promise((resolve, reject) => {
            conn.commit(async err => {
                if (err) {
                    await this.rollback(conn);
                    reject(err);
                } else {
                    conn.destroy();
                    resolve();
                }
            });
        });
    }

    async query(conn: PoolConnection, q: string | QueryOptions, values: any): Promise<Callback> {
        return new Promise((resolve, reject) => {
            conn.query(q, values, (err: MysqlError | null, results?: any, fields?: FieldInfo[]) => {
                if (err) return reject(err);
                resolve({ results, fields });
            })
        });
    }
}

export const myDB = (settings: DatabaseConfig) => new MyDatabase(settings);