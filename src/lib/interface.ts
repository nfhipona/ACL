import {
    PoolConnection,
    FieldInfo,
    QueryOptions
} from 'mysql';

export interface DatabaseConfig {
    connectionLimit: number,
    host: string,
    user: string,
    password: string,
    database: string
}

export interface Database {
    connection(): Promise<PoolConnection>
    transaction(): Promise<PoolConnection>
    rollback(conn: PoolConnection): Promise<void>
    commit(conn: PoolConnection): Promise<void>
    query(conn: PoolConnection, q: string | QueryOptions, values: any): Promise<Callback>
}

export interface Callback {
    results?: any,
    fields?: FieldInfo[]
}