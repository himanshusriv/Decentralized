
async function Connect() {
    if(window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
            await ethereum.enable();
            const accounts = await web3.eth.getAccounts();
            window.userAddress = accounts[0];
            window.localStorage.setItem('userAddress', accounts[0]);
			window.userAddress = window.localStorage.getItem('userAddress');
            Redirect();
            showAddress();
        } catch (error) {
            console.error(error)
        }
    } else {
        alert('No ETH Browser extension detected.')
    }
}

function Redirect() {
    //const owner = await window.contract.methods.owner().call();
    if(window.userAddress == "0x7939846A9D05469eBf6a1a232ebE64fb6A238F51") {
        window.location.replace("./addCandidate.html");
		alert('Login as Admin')
    } else {
        window.location.replace("./voting.html");  
		alert('Login as User.')
    }
}
