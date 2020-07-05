import React, { useContext } from 'react'
import { RouteComponentProps } from 'react-router-dom'
import { useFormValidator, PrivateRouteRedirectState, UserStateContext, LanguageChooser, LoginModel, UserLoginController, IResult, LoginResultData, UserLoginSuccess, IUserUpdate, SaveLogin, LoginTokenModel } from 'etsoo-react'
import { Settings } from '../Settings'

import { Button, Container, Avatar, Typography, TextField, FormControlLabel, Box, Checkbox, makeStyles } from '@material-ui/core'
import { LockOutlined } from '@material-ui/icons'

import * as Yup from 'yup'

// Styles
const useStyles = makeStyles((theme) => ({
    paper: {
      marginTop: theme.spacing(3),
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
    },
    avatar: {
      margin: theme.spacing(1),
      backgroundColor: theme.palette.secondary.main,
    },
    form: {
      width: '100%', // Fix IE 11 issue.
      marginTop: theme.spacing(1),
    },
    language: {
      marginLeft: 'calc(100% - 60px)',
      marginBottom: -60
    },
    submit: {
      margin: theme.spacing(3, 0, 2),
    }
}))

// Form validation schema
const validationSchemas = Yup.object({
  // Lazy idea to distinguish number id or email address
  id: Yup.lazy<string | undefined>((value) => {
      if(value && value.indexOf('@') !== -1) {
        return Yup.string().email("Email address is invalid")
      } else {
        return Yup.string().required("User id or email is required").matches(/^\d+$/g, 'Number id is invalid')
      }
    }),
  password: Yup.string()
    .required("Please enter your password")
    .min(4, "Password must contain at least 4 characters"),
  // Format data type only
  save: Yup.boolean()
})

// Login component
const Login: React.FunctionComponent<RouteComponentProps> = (props) => {
  // User sate
  let { state: userState, dispatch: userDispatch } = useContext(UserStateContext)

  // Style
  const classes = useStyles()

  // Form validator
  const { blurHandler, changeHandler, errors, texts, updateResult, validateForm } = useFormValidator(validationSchemas, 'id')

  // Controller, should be in the function main body
  const api = new UserLoginController(userState, {}, userDispatch)

  // User component ref
  const userRef = React.useRef<HTMLInputElement>()

  // Password component ref
  const passwordRef = React.useRef<HTMLInputElement>()

  // Login success
  const loginSuccess: UserLoginSuccess = (userId: number) => {
    return new Promise((resolve) => {
      // Format data
      const newData: IUserUpdate = {
        name: 'Garry Xiao',
        organizationName: 'Coretex'
      }

      // Return
      resolve(newData)
    })
  }

  // Login result
  const loginResult = React.useCallback((result: IResult<LoginResultData>) => {
    // Hide loading bar
    api.singleton.showLoading(false)

    // Error, return anyway
    if(!result.ok) {
      updateResult(result)
      return
    }

    // Redirect after successfully log in
    let redirectUrl = null
    const referrer = (props.location.state as PrivateRouteRedirectState)?.referrer
    if(referrer && referrer.pathname)
      redirectUrl = referrer.pathname + referrer.search
    else if(props.location.search) {
      redirectUrl = new URLSearchParams(props.location.search).get('redirect')
    }

    // referer should not contain '://' to avoid any open redirect attacks posibility
    if(redirectUrl == null || redirectUrl === '/login' || redirectUrl.indexOf('://') > 0) {
        redirectUrl = '/main'
    }

    props.history.push(redirectUrl)
  }, [api.singleton, props, updateResult])

  // Load event
  React.useEffect(() => {
    const saveLoginData = SaveLogin.get()
    if(saveLoginData) {
      // Saved raw id
      if(userRef && userRef.current)
        userRef.current.value = saveLoginData.rawId

      // Try to login with token
      if(saveLoginData.token) {
        // Model
        const loginTokenData: LoginTokenModel = {
          id: saveLoginData.id,
          token: saveLoginData.token
        }

        // Show loading bar
        api.singleton.showLoading()

        // Act
        api.loginToken(loginTokenData, loginSuccess).then(result => {
          // Do result only successful
          if(result.ok)
            loginResult(result)
          else {
            // Hide loading bar
            api.singleton.showLoading(false)

            // Focus the password input
            if(passwordRef && passwordRef.current)
              passwordRef.current.focus()
          }
        })
      } else {
        // If id is ready, set focus on password component
        if(passwordRef && passwordRef.current)
          passwordRef.current.focus()
      }
    }
  }, []) // [] means only executed one time

  // Login action
  async function doLogin(event: React.FormEvent<HTMLFormElement>) {
      // Prevent default action
      event.preventDefault()

      // Form JSON data
      const data = await validateForm(new FormData(event.currentTarget))
      if(data === null)
        return

      // Show loading bar
      api.singleton.showLoading()

      // Act
      const result = await api.login(data as LoginModel, loginSuccess)

      // Do result
      loginResult(result)
  }

  return (
    <Container component="main" maxWidth="xs">
      <LanguageChooser className={classes.language} items={Settings.supportedLanguages} title="Languages" selectedValue={Settings.currentLanguage} />
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlined />
        </Avatar>
        <Typography component="h1" variant="h5">
          Sign in
        </Typography>
        <form className={classes.form} onSubmit={doLogin} noValidate>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="id"
            label="Id or Email"
            name="id"
            error={errors('id')}
            helperText={texts('id')}
            onChange={changeHandler}
            onBlur={blurHandler}
            autoComplete="email"
            autoFocus
            inputRef={userRef}
          />
          <TextField
            variant="outlined"
            margin="normal"
            type="password"
            required
            fullWidth
            name="password"
            error={errors('password')}
            helperText={texts('password')}
            onChange={changeHandler}
            onBlur={blurHandler}
            label="Password"
            id="password"
            autoComplete="current-password"
            inputRef={passwordRef}
          />
          <FormControlLabel
            control={<Checkbox name="save" value="true" color="primary" />}
            label="Remember me"
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
          >
            Sign In
          </Button>
        </form>
      </div>
      <Box mt={6}>
        <Typography color="textSecondary" align="center">Vehicle Management System</Typography>
        <Typography variant="body2" color="textSecondary" align="center">Designed by Garry Xiao</Typography>
      </Box>
    </Container>
  )
}

export default Login