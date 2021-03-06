# Read Me

## It's not done yet. 

This is a cumstom tableview designed to show comments for news and the relationship between replies and their qoutes.

<img src="./screenshot/scene_1.png" width = "250" height = "445" alt="scene 1" align=center />

## 1. Main Functions

### Show all content of a long comment
<img src="./screenshot/scene_2.png" width = "250" height = "445" alt="scene 2" align=center />

### Show the hidden quote
<img src="./screenshot/scene_3.png" width = "250" height = "445" alt="scene 3" align=center />

## 2. Data Sample
```
{
    "msg": "error",
    "code": 1,
    "data": {
        "newListSize": 3465,
        "commentIds":[
                      "70260328,70255891,70263347,70262576,70267592,70269439,70273016",
                      "70273016"
                      ],
        "comments": {
            "70821771": {
                "buildLevel": 69,
                "ip": "60.216.*.*",
                "against": 0,
                "content": "You can't get to that level.",
                "source": "wb",
                "shareCount": 0,
                "user": {
                    "nickname": "Blevins",
                    "userId": 90400553,
                    "id": "dGFydGhhc0AxNjMuY29t",
                    "location": "MN"
                },
                "anonymous": false,
                "vote": 0,
                "commentId": 70821771,
                "isDel": false,
                "postId": "BHLQDHE500014AED_BHNKPC06",
                "favCount": 0,
                "createTime": "2018-04-28 21:29:04"
            },
            "70255891": {"buildLevel": 2, "ip": "124.239.*.*", "against": 1, "content": "I don't care how disappointing it might've been as you've been working toward that dream, I don't care how disappointing it might've been as you've been working toward that dream, I don't care how disappointing it might've been as you've been working toward that dream, I don't care how disappointing it might've been as you've been working toward that dream, I don't care how disappointing it might've been as you've been working toward that dream, I don't care how disappointing it might've been as you've been working toward that dream,", "source": "ph", "shareCount": 0, "user": {"id": "ZTg3OWFjYTNiN2QzMTQ3MDBjNjhiYmRmM2Y3MThhM2VAdGVuY2VudC4xNjMuY29t", "nickname": "Baird", "userId": 84551031, "location": "WV", "avatar": "http://q.qlogo.cn/qqapp/100346651/E879ACA3B7D314700C68BBDF3F718A3E/100"}, "anonymous": false, "vote": 29, "commentId": 70255891, "isDel": false, "postId": "BHLQDHE500014AED_BHM1LNI3", "favCount": 0, "createTime": "2018-04-28 20:22:04"}
        }
    }
}
```

## 3. How to integrate this lib?


Like the example in ``` CommentViewController```

Initialize ```JJCommentTableView```

```
let table = JJCommentTableView(1) // 1 refer to how many seciotns the table has
...
if let data = dict["data"] as? [String:Any] {
	if let rawComments = data["comments"] as? [String:[String:Any]],
	let rawStructure = data["commentIds"] as? [String] {
	table.reload(comments: rawComments, structure: rawStructure, in: 0)
	}
}

```

If you want to append data, use
```
func append(comments:[String:[String:Any]], structure:[String], in section:Int) 
```