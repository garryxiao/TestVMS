import { SearchModel, EntityController, IApiConfigs, IApiUser, ApiModule, ISearchResult, ISearchItem } from "etsoo-react"

/**
 * Vehicle search item interface
 */
export interface VehicleSearchItem extends ISearchItem {
    /**
     * Id of the entity
     */
    id: number

    /**
     * Device id of the black box
     */
    device_id: string

    /**
     * Plate no of the vehicle
     */
    plate_no: string

    /**
     * Time of creation
     */
    creation: Date
}

/**
 * Vehicle API controller
 */
export class VehicleController extends EntityController
{
    /**
     * Constructor
     * @param user Current user
     */
    constructor(user: IApiUser, configs: IApiConfigs) {
        super(user, {
            identity: 'vehicle',
            module: ApiModule.System
        }, configs)
    }

    /**
     * Search data
     * @param model Search condition data model
     */
    async search(model: SearchModel | undefined = undefined) {
        return await super.searchBase<ISearchResult<VehicleSearchItem>, SearchModel>(model)
    }
}