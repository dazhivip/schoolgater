//
//  LogicGlobalDefine.h
//  Logic
//
//  Created by Ryan on 14-6-5.
//  Copyright (c) 2014年 _MyCompany__. All rights reserved.
//

#ifndef Logic_LogicGlobalDefine_h
#define Logic_LogicGlobalDefine_h


// 服务器访问地址以及各端口URL定义
#define kServerUrl              @"http://www.schoolgater.com"    // 服务器地址


#define kGetGlassList(pageIndex,titStr) [NSString stringWithFormat:@"%@/download_glass.php?start=%d&count=12&category=%@",kServerUrl,pageIndex,titStr]

// 明星首字母
#define kStarsFirstName [NSString stringWithFormat:@"%@/get_star_image_android.php?fetch=name_list", kServerUrl]

//明星名字
#define kStarName(fName) [NSString stringWithFormat:@"%@/get_star_images.php?fetch=name_list&letter=%@", kServerUrl,fName]

//获取分类
#define kGetCategories [NSString stringWithFormat:@"http://www.schoolgater.com/return_cat.php?category=I_want_to_get_categories"]
//获取图片列表
#define kGetPhotoFlow(name) [NSString stringWithFormat:@"%@/get_star_images.php?fetch=images&name=%@", kServerUrl,name]

//获取face++ APIKEY
#define kGetFaceKEY [NSString stringWithFormat:@"%@/action_face_id_key.php?facekey=xiaomenkou",kServerUrl]
//获取分享内容
#define kGetShareContent [NSString stringWithFormat:@"http://schoolgater.com/share_content.php"]
#endif




















