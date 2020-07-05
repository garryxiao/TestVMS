import React from 'react'
import { RouteComponentProps } from "react-router-dom"
import { UserStateContext, CustomerSearchModel, useDimensions, searchLayoutFormat, ISearchResult, ListItemRendererProps, IDynamicData, Utils, SearchPage, IClickAction } from 'etsoo-react'
import { MainContainer } from '../MainContainer'
import { Typography, makeStyles, Card, CardHeader, CardContent, Avatar, Grid, CircularProgress } from '@material-ui/core'
import { red } from '@material-ui/core/colors'
import { VehicleController, VehicleSearchItem } from '../VehicleController'

// Styles
const useStyles = makeStyles((theme) => ({
    tableRow: {
        padding: theme.spacing(2),
        [theme.breakpoints.down('xs')]: {
            padding: theme.spacing(1)
        }
    },
    bold: {
        paddingLeft: theme.spacing(1),
        fontWeight: 'bold'  
    },
    total: {
        display: 'grid',
        gridTemplateColumns: '50% 50%'
    },
    totalCell: {
        fontWeight: 'bold'
    },
    card: {
        height: '100%'
    },
    cardContent: {
        paddingTop: 0
    },
    avatar: {
        width: theme.spacing(3),
        height: theme.spacing(3),
        backgroundColor: red[500]
    },
    description: {
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        display: '-webkit-box',
        '-webkit-line-clamp': 2,
        '-webkit-box-orient': 'vertical'
    }
}))

function Search(props: RouteComponentProps) {
    // Style
    const classes = useStyles()

    // User state
    const { state: userState } = React.useContext(UserStateContext)

    // Controller, should be in the function main body
    const api = new VehicleController(userState, {})

    // Calculate dimensions
    const {ref, dimensions} = useDimensions<HTMLElement>(true)

    // Read cache data
    const tryCache = props.history.action === 'POP'

    // Width & Height
    const width = (dimensions?.width) || 0
    const height = (dimensions?.height) || 0
    const md = (width <= 960)

    const rowHeight = (md ? 200 : 53)

    // Format header labels
    const formatLabels = (results: ISearchResult<VehicleSearchItem>) => {
        if(results.layouts) {
            searchLayoutFormat(results.layouts, formatLabel)
        }
    }

    // Format header label
    const formatLabel = (field: string) => {
        return Utils.snakeNameToWord(field)
    }

    // More actions
    const moreActions: IClickAction[] = []

    // Search parameters
    const [ searchProps ] = React.useState<IDynamicData>({})

    // Load datal
    const loadItems = async (page: number, records: number, orderIndex?: number) => {
        // Combine parameters
        const conditions: CustomerSearchModel = Object.assign({}, searchProps, { page, records, orderIndex })

        // Read results
        const results = await api.search(conditions)

        // Custom label formatter
        if(page === 1)
            formatLabels(results)

        // Return to the infinite list
        return results
    }

    // Mobile list item renderer
    const itemRenderer = md ? (props: ListItemRendererProps, className: string, parentClasses: string[]) => {
        // Change parent style
        parentClasses.splice(0, parentClasses.length)

        // parentClasses.splice(0, 1)
        parentClasses.push(classes.tableRow)

        // <Skeleton variant="text" animation="wave" />
        const data = props.data! as VehicleSearchItem
        if(data.loading) {
            return <CircularProgress size={20} />
        } else {
            return <Card className={classes.card}>
                <CardHeader
                    avatar={
                        <Avatar className={classes.avatar}>V</Avatar>
                    }
                    title={data.plate_no}
                    subheader={data.creation}
                />
                <CardContent className={classes.cardContent}>
                    <Grid container spacing={1}>
                        <Grid item xs={12} sm={12}>
                            <Typography component="span">{formatLabel('Device id')}:</Typography>
                            <Typography component="span" className={classes.bold}>{data.device_id}</Typography>
                        </Grid>
                        <Grid item>
                            <Typography variant="body2" className={classes.description}>{data.description}</Typography>
                        </Grid>
                    </Grid>
                </CardContent>
            </Card>
        }
    } : undefined

    // Add handler
    const onAddClick = (event: React.MouseEvent) => {
        props.history.push('/vehicle/add')
    }

    // Item click handler, no action under md size
    const onItemClick = (event: React.MouseEvent, item?: VehicleSearchItem) => {
        // Go to edit page
        if(item) {
            props.history.push('/vehicle/edit/' + item.id)
        }
    }

    return (
        <MainContainer padding={0} ref={ref}>
            <SearchPage height={height} rowHeight={rowHeight} itemRenderer={itemRenderer} loadItems={loadItems} moreActions={moreActions} onAddClick={onAddClick} onItemClick={ onItemClick}  padding={1} searchProps={searchProps} tryCache={tryCache} width={width} />
        </MainContainer>
    )
}

export default Search