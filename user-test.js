module.exports = {
    "__comment":   "Đây là định nghĩa cấu trúc account cho easywebhub, có ý kiến vui lòng trao đổi với baotnq",
    "accountId":   "0001",
    "accountType": "user", // user or company,
    "username":    "baotnq",
    "password":    "xxxxx",   //not show on client,
    "status":      "verified",

    "info": { //lưu thông tin account user hoặc cho cả company,
        "name":    "Trịnh Ngọc Quốc Bảo",
        "age":     31,
        "sex":     "nam",
        "address": ""
    },

    "websites": [
        {
            "id":          "easywebhub-xxxxx",
            "companyId":   "baotnq",   //sau khi create new website, companyId chính là userName, sau này đổi thành companyId riêng ,
            "name":        "website-easy",
            "displayName": "Website of easywebhub",
            "accessLevel": ["creator", "admin"],
            "url":         "http://easywebhub.com",
            "stagging":    [    // dùng để lưu trữ thay đổi, preview cá nhân, nôi bộ team ,
                {
                    "name":        "Github Environment",
                    "hosting-fee": "free",
                    "url":         "https://easywebhub.github.io/easy-websites",
                    "git":         "https://github.com/easywebhub/easy-websites.git"
                }
            ],
            "production":  [   // dùng để deploy cho server chính, hoặc để demo show cho khách hàng,...,
                {
                    "name":        "Github Environment",
                    "hosting-fee": "free",
                    "url":         "https://easywebhub.github.io/easy-websites",
                    "git":         "https://github.com/easywebhub/easy-websites.git"
                },
                {
                    "name":        "EasyWeb Environment",
                    "hosting-fee": "basic",    // paid options:  basic | advanced ,
                    "url":         "https://easy-web.easywebhub.com",
                    "git":         "https://git.easywebhub.com/easy-websites.git"
                },
            ]
        },

        {
            "id":          "easywebhub-xxxxx",
            "name":        "website-easy",
            "displayName": "Website of easywebhub",
            "accessLevel": ["contentor"],
            "url":         "http://easywebhub.com",
            "stagging":    [  //vẫn cần để lưu dữ liệu  : SYNC  ,
                {
                    "name":        "Github Environment",
                    "hosting-fee": "free",
                    "url":         "https://easywebhub.github.io/easy-websites",
                    "git":         "https://github.com/easywebhub/easy-websites.git"
                }
            ],
            "production":  [
                // nothing for Contentor access level ,
            ]
        }
    ]
};
