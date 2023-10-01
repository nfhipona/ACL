import { Database } from "./lib/interface"
import { Request, Response } from 'express';

export class ACL {
    db: Database
    constructor(db: Database) {
        this.db = db;
    }
}
export default (db: Database) => {
    const acl = async (resource_code: string, mode: string): Promise<Function> => {
        return async (req: Request, res: Response, next: Function): Promise<void> => {
            const decoded: any = req.get('decoded_token');
            const role_id = decoded.role_id;

            try {
                const conn = await db.connection();
                const queryStr = `CALL ACL_VALIDATE(?, ?, ?, 1)`;
                const { results } = await db.query(conn, queryStr, [resource_code, role_id, mode]);
                console.log(`results: `, results);

                next();
            } catch (err) {
                const errMsg = 'Your account has a limited to no access to this resource, or the resource is no longer active and/or available.';
                res.status(401)
                    .send({
                        success: false,
                        message: errMsg,
                        data: null
                    })
                    .end();
            }
        }
    }

    return {
        acl
    }
}