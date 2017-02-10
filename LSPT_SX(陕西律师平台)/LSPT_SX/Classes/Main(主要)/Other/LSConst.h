//
//  LSConst.h
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define LSGlobalColor LSColor(65, 175, 216)
#define LSGrayColor LSColor(220,220,220)
#define LSBlueColor LSColor(236,244,249)
#define LSNotificationCenter [NSNotificationCenter defaultCenter]

extern NSString *const LSModifyDidClickNotification;
extern NSString *const LSDeleteDidClickNotification;
extern NSString *const LSLitigantDidClickNotification;
extern NSString *const LSMaterialDidClickNotification;
extern NSString *const LSSubmitDidClickNotification;
extern NSString *const LSAssessDidClickNotification;

extern NSString *const LSFGModifyDidClickNotification;
extern NSString *const LSFGDeleteDidClickNotification;
extern NSString *const LSPJModifyDidClickNotification;
extern NSString *const LSLXFGModifyDidClickNotification;
extern NSString *const LsLitigantSaveButtonDidClickNotification;
// 文件上传专用地址
extern NSString *const fileUploadUrl;
extern NSString *const downUrl;
//根目录地址
extern NSString *const BaseUrl;
// 律师登陆
extern NSString *const LoginUrl;
//修改密码
extern NSString *const ModifyPasswordUrl;
//网上阅卷查询接口
extern NSString *const WDAJUrl;
//我的案件详情接口
extern NSString *const WDAJDetailUrl;
//网上阅卷查询接口
extern NSString *const WSYJUrl;
//网上阅卷新增和修改接口
extern NSString *const WSYJSaveOrUpdateUrl;
//网上阅卷删除接口
extern NSString *const WSYJDelUrl;
//庭审避让查询接口
extern NSString *const TSBRUrl;
//庭审避让新增和修改接口
extern NSString *const TSBRSaveOrUpdateUrl;
//庭审避让删除接口
extern NSString *const TSBRDelUrl;
//联系法官查询接口
extern NSString *const LXFGUrl;
//联系法官新增和修改接口
extern NSString *const LXFGSaveOrUpdateUrl;
//联系法官删除接口
extern NSString *const LXFGDelUrl;
//待收文书查询接口
extern NSString *const DSWSUrl;
//网上立案查询接口
extern NSString *const WSLAUrl;
//提交网上立案接口
extern NSString *const WSLASubUrl;
//网上立案新增或修改接口
extern NSString *const WSLASaveOrUpdateUrl;
//删除网上立案件接口
extern NSString *const WSLADelUrl;
//案号接口
extern NSString *const GetAhInfoUrl;
//法院信息接口
extern NSString *const GetFyInfoUrl;
//案由接口
extern NSString *const GetAyInfoUrl;
//管辖依据接口
extern NSString *const GetGxyjInfoUrl;
//诉讼地位接口
extern NSString *const GetSsdwInfoUrl;
//国籍接口
extern NSString *const GetGjInfoUrl;
//民族接口
extern NSString *const GetMzInfoUrl;
//政治面貌接口
extern NSString *const GetZzmmInfoUrl;
//文化程度接口
extern NSString *const GetWhcdInfoUrl;
//材料名称
extern NSString *const GetClmcInfoUrl;
//诉讼材料接口
extern NSString *const querySSCLUrl;
//诉讼保全查询接口
extern NSString *const SSBQUrl;
//诉讼保全保存或修改接口
extern NSString *const SSBQSaveOrChangeUrl;
//诉讼保全删除接口
extern NSString *const SSBQDelUrl;
//延期开庭查询接口
extern NSString *const YQKTUrl;
//延期开庭保存或修改接口
extern NSString *const YQKTSaveOrChangeUrl;
//延期开庭删除接口
extern NSString *const YQKTDelUrl;
//调查令查询接口
extern NSString *const DCLUrl;
//调查令保存或修改接口
extern NSString *const DCLSaveOrChangeUrl;
//调查令删除接口
extern NSString *const DCLDelUrl;
//材料提交查询接口
extern NSString *const GetCLTJUrl;
//材料提交保存接口
extern NSString *const SaveCLTJUrl;
//材料提交提交接口
extern NSString *const PostCLTJUrl;
//材料提交删除接口
extern NSString *const DeleteCLTJUrl;
//满意度评价接口
extern NSString *const mydPjUrl;
//文件上传接口
extern NSString *const uploadFileUrl;
//文件下载接口
extern NSString *const downloadFileUrl;
//文件提交接口
extern NSString *const CLTJUrl;
//删除接口
extern NSString *const CLDelUrl;
//表扬建议 查询接口
extern NSString *const byjyQueryUrl;
//表扬建议 新增接口
extern NSString *const byjySaveUrl;
//表扬建议提交接口
extern NSString *const byjyTJUrl;
//审判程序接口
extern NSString *const GetSpcxInfoUrl;
//案件当事人接口
extern NSString *const DsrUrl;
//删除当事人
extern NSString *const DelDsrUrl;
//保存当事人接口
extern NSString *const SaveDsrUrl;
//诉讼材料接口
extern NSString *const SsclUrl;
//保存诉讼材料
extern NSString *const SaveSsclUrl;
//删除讼诉材料
extern NSString *const DelSsclUrl;