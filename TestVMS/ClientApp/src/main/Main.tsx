import React from 'react'
import { RouteComponentProps } from 'react-router-dom'
import { Typography } from '@material-ui/core'
import { MainContainer } from '../MainContainer'
import { UserStateContext } from 'etsoo-react'

function Main(props: RouteComponentProps) {
    // User state
    const { state } = React.useContext(UserStateContext)

    return (
        <MainContainer padding={2}>
            <Typography>Hi {state.name}, welcome to VMS</Typography>
        </MainContainer>
    )
}

export default Main