const BASE_URL = 'https://graph.microsoft.com/v1.0/';
const SITE_URL = 'sites/{siteId}/';
const DRIVE_URL = 'drives/{driveId}/';
const ITEM_URL = 'items/{itemId}/content?$format=pdf'


const METHOD = 'GET';

export default function convertToPdfHelper({token, siteId, driveId, itemId}) {

    let endpoint = BASE_URL + SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId);

    return fetch(endpoint, {
        
        method: METHOD,
        headers: {
            'Authorization': 'Bearer ' + token,
            'Accept': 'application/pdf',
            'Accept-Encoding': 'gzip, deflate, br'
        },
    })
    .catch(error => {
          console.error('Error:', error);
    });
}