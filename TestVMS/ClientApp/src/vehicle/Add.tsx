import React from 'react'
import { MainContainer } from '../MainContainer'
import { StyledForm, useFormValidator, UserStateContext, IViewModel, IResult, IdResultData, IEditData, ResultError } from 'etsoo-react'
import { Button, Grid, TextField } from '@material-ui/core'
import * as Yup from 'yup'
import { VehicleController } from '../VehicleController'
import { RouteComponentProps } from 'react-router-dom'

// Form validation schema
const validationSchemas = Yup.object({
    plateNO: Yup.string().required('Please enter the plate no.'),
    deviceId: Yup.string().required('Please enter the device id')
})

// View data
class VehicleData implements IViewModel {
    id?: number
    plateNo?: string
    deviceId?: string
    description?: string
}

export default function VehicleAdd(props: RouteComponentProps<{id: (string | undefined)}>) {
    // Form validator
    const { blurFormHandler, changeFormHandler, errors, texts, validateForm } = useFormValidator(validationSchemas, 'plateNo')
    
    // User state
    const { state } = React.useContext(UserStateContext)

    // Parameters
    const { id } = props.match.params

    // Controller, should be in the function main body
    const api = new VehicleController(state, { defaultLoading: true })

    // Create GUID for quick input
    const createGUID = () => {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8)
            return v.toString(16)
        })
    }

    // Edit or default data
    const [viewData, setViewData] = React.useState<VehicleData>(id ? {} : {
        deviceId: createGUID()
    })

    // Common result handler
    const resultHandler = (result: IResult<any>) => {
        if(result.ok) {
            // Success
            props.history.push('/vehicle/search')
        } else {
            // Error popup
            api.singleton.reportError(ResultError.format(result))
        }
    }

    // Click to delete handler
    const deleteHandler = (event: React.MouseEvent<HTMLButtonElement>) => {
        api.singleton.confirm('Are you sure to delete the vehicle?', 'Delete', (ok) => {
            if(ok) {
                api.delete(id!).then(result => {
                    // Deal with result
                    resultHandler(result)
                })
            }
        })
    }

    // Submit form
    async function doSubmit(event: React.FormEvent<HTMLFormElement>) {
        // Prevent default action
        event.preventDefault()
  
        // Form JSON data
        let data = await validateForm(new FormData(event.currentTarget))
        if(data === null)
          return

        // Result
        let result: IResult<IdResultData>
  
        // Act
        if(id) {
            result = await api.edit(id, data as IEditData)
        } else {
            result = await api.add(data)
        }
  
        // Deal with result
        resultHandler(result)
    }

    React.useEffect(() => {
        if(id) {
            api.viewF<VehicleData>((data) => {
                // Transform fields name
                return {
                    plateNo: data['plate_no'],
                    deviceId: data['device_id'],
                    description: data['description']
                }
            }, parseFloat(id)).then(data => {
                // Edit data
                // Set component's key to reset 'defaultValue', otherwise, no update, tricky enough
                // https://github.com/facebook/react/issues/4101
                setViewData(data)
            })
        }
    }, [id])

    return (
        <MainContainer maxWidth="md">
            <StyledForm onSubmit={doSubmit}>
                <Grid container justify="space-around">
                    <Grid item xs={12} sm={5}>
                        <TextField
                            name="plateNO"
                            fullWidth
                            required
                            key={viewData.plateNo}
                            defaultValue={viewData.plateNo}
                            error={errors('plateNO')}
                            helperText={texts('plateNO')}
                            onChange={changeFormHandler}
                            onBlur={blurFormHandler}
                            InputLabelProps={{
                                shrink: true
                            }}
                            inputProps={{ maxLength: 8 }}
                            label="Plate no."
                        />
                    </Grid>
                    <Grid item xs={12} sm={5}>
                        <TextField
                            name="deviceId"
                            fullWidth
                            required
                            key={viewData.deviceId}
                            defaultValue={viewData.deviceId}
                            error={errors('deviceId')}
                            helperText={texts('deviceId')}
                            onChange={changeFormHandler}
                            onBlur={blurFormHandler}
                            InputLabelProps={{
                                shrink: true
                            }}
                            label="Device id"
                        />
                    </Grid>
                    <Grid item xs={12} sm={11}>
                        <TextField
                            name="description"
                            fullWidth
                            defaultValue={viewData.description}
                            multiline
                            rowsMax={3}
                            InputLabelProps={{
                                shrink: true
                            }}
                            inputProps={{ maxLength: 1280 }}
                            label="Description"
                        />
                    </Grid>
                    <Grid item xs={12} sm={5} hidden={!id}>
                        <Button
                            fullWidth
                            variant="contained"
                            color="secondary"
                            onClick={deleteHandler}
                        >
                            Delete
                        </Button>
                    </Grid>
                    <Grid item xs={12} sm={5}>
                        <Button
                            fullWidth
                            type="submit"
                            variant="contained"
                            color="primary"
                        >
                            Submit
                        </Button>
                    </Grid>
                </Grid>
            </StyledForm>
        </MainContainer>
    )
}