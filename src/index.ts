
module.exports = (database) => {
    const acl = async (resource_code: string, role_id: string, mode: string): Promise<Function> => {
        return async (req: Request, res: Response, next: Function): Promise<void> => {

        }
    }

    return {
        acl
    }
}