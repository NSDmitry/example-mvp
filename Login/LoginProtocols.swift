protocol LoginViewControllerProtocol: class {
    func connectDone()
    func connectError(error: DomophoneError)
}

protocol LoginRouterProtocol {
    func openResetAccessViewController()
    func openIntercoms(user: UserAccount)
    func openDebugMenu()
}

protocol LoginPresenterProtocol {
    func openDebug()
    func authUser(authData: AuthData)
    func openResetSmsViewController()
}
