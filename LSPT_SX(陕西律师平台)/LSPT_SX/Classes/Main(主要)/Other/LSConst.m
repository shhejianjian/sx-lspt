//
//  LSConst.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//
#import <Foundation/Foundation.h>

NSString *const LSModifyDidClickNotification = @"LSModifyDidClickNotification";
NSString *const LSDeleteDidClickNotification = @"LSDeleteDidClickNotification";
NSString *const LSLitigantDidClickNotification = @"LSLitigantDidClickNotification";
NSString *const LSMaterialDidClickNotification = @"LSMaterialDidClickNotification";
NSString *const LSSubmitDidClickNotification = @"LSSubmitDidClickNotification";

NSString *const LSFGModifyDidClickNotification = @"LSFGModifyDidClickNotification";
NSString *const LSFGDeleteDidClickNotification = @"LSFGDeleteDidClickNotification";
NSString *const LSPJModifyDidClickNotification = @"LSPJModifyDidClickNotification";
NSString *const LSLXFGModifyDidClickNotification = @"LSLXFGModifyDidClickNotification";
NSString *const LsLitigantSaveButtonDidClickNotification = @"litigantSaveButtonDidClickNotification";
NSString *const LSAssessDidClickNotification = @"LSAssessDidClickNotification";

//文件上传专用接口
NSString *const fileUploadUrl = @"http://192.168.7.100:7070/upload.do";
NSString *const downUrl = @"http://192.168.7.100:7070/downFilePhone.do";
NSString *const BaseUrl = @"http://192.168.7.100:7070";
NSString *const LoginUrl = @"m/login.do";

//修改密码/m/getInfo.do
NSString *const ModifyPasswordUrl = @"m/updateLawyer.do";
//网上阅卷查询接口
NSString *const WDAJUrl = @"m/wdajquery.do";
//我的案件详情接口
NSString *const WDAJDetailUrl = @"m/wdajinfo.do";
//网上阅卷查询接口
NSString *const WSYJUrl = @"m/wsyjQuery.do";
//网上阅卷新增和修改接口
NSString *const WSYJSaveOrUpdateUrl = @"/m/wsyjSaveOrUpdate.do";
//网上阅卷删除接口
NSString *const WSYJDelUrl = @"m/wsyjDel.do";
//庭审避让查询接口
NSString *const TSBRUrl = @"m/tsbrQuery.do";
//庭审避让新增和修改接口
NSString *const TSBRSaveOrUpdateUrl = @"m/tsbrSaveOrUpdate.do";
//庭审避让删除接口
NSString *const TSBRDelUrl = @"m/tsbrDel.do";
//联系法官查询接口
NSString *const LXFGUrl = @"m/lxfgquery.do";
//联系法官新增和修改接口
NSString *const LXFGSaveOrUpdateUrl = @"m/lxfgsaveorSubmit.do";
//联系法官删除接口
NSString *const LXFGDelUrl = @"m/lxfgdel.do";
//待收文书查询接口
NSString *const DSWSUrl = @"m/dswsQuery.do";
//网上立案查询接口
NSString *const WSLAUrl = @"m/wslaquery.do";
//提交网上立案接口
NSString *const WSLASubUrl = @"m/wslasub.do";
//网上立案新增或修改接口
NSString *const WSLASaveOrUpdateUrl = @"m/wslaSaveOrUpdate.do";
//删除网上立案件接口
NSString *const WSLADelUrl = @"m/delWsla.do";
//案号
NSString *const GetAhInfoUrl = @"m/getInfo.do";
//法院信息接口
NSString *const GetFyInfoUrl = @"m/getFyInfo.do";
//案由接口
NSString *const GetAyInfoUrl = @"m/getAyInfo.do";
//管辖依据接口
NSString *const GetGxyjInfoUrl = @"m/getGxyjInfo.do";
//诉讼地位接口
NSString *const GetSsdwInfoUrl = @"m/getSsdwInfo.do";
//国籍接口
NSString *const GetGjInfoUrl = @"m/getGjInfo.do";
//民族接口
NSString *const GetMzInfoUrl = @"m/getMzInfo.do";
//政治面貌接口
NSString *const GetZzmmInfoUrl = @"m/getZzmmInfo.do";
//文化程度接口
NSString *const GetWhcdInfoUrl = @"m/getWhcdInfo.do";
//材料名称
NSString *const GetClmcInfoUrl = @"m/getClmcInfo.do";
//诉讼材料接口
NSString *const querySSCLUrl = @"m/getJynr.do";
//材料提交查询接口
NSString *const GetCLTJUrl = @"m/wjxxQuery.do";
//诉讼保全查询接口
NSString *const SSBQUrl = @"m/ssbqQuery.do";
//诉讼保全查询或修改接口
NSString *const SSBQSaveOrChangeUrl = @"m/ssbqSaveOrUpdate.do";
//诉讼保全删除接口
NSString *const SSBQDelUrl = @"m/ssbqDel.do";
//延期开庭查询接口
NSString *const YQKTUrl = @"m/yqktQuery.do";
//延期开庭保存或修改接口
NSString *const YQKTSaveOrChangeUrl = @"m/yqktSaveOrUpdate.do";
//延期开庭删除接口
NSString *const YQKTDelUrl = @"m/yqktDel.do";
//调查令查询接口
NSString *const DCLUrl = @"m/dclQuery.do";
//调查令保存或修改接口
NSString *const DCLSaveOrChangeUrl = @"m/dclSaveOrUpdate.do";
//调查令删除接口
NSString *const DCLDelUrl = @"m/dclDel.do";
//材料提交保存接口
NSString *const SaveCLTJUrl = @"m/wjxxSave.do";
//材料提交提交接口
NSString *const PostCLTJUrl = @"m/wjxxSub.do";
//材料提交删除接口
NSString *const DeleteCLTJUrl = @"m/wjxxDel.do";
//满意度评价接口
NSString *const mydPjUrl = @"m/pjSave.do";
//文件上传接口
NSString *const uploadFileUrl = @"upload.do";
//文件下载接口
NSString *const downloadFileUrl = @"downFilePhone.do";
//提交接口
NSString *const CLTJUrl = @"m/wjxxSub.do";
//删除接口
NSString *const CLDelUrl = @"m/wjxxDel.do";
//表扬建议 查询接口
NSString *const byjyQueryUrl = @"m/byjyQuery.do";
//表扬建议 新增接口
NSString *const byjySaveUrl = @"m/byjySave.do";
//表扬建议提交接口
NSString *const byjyTJUrl = @"m/byjySub.do";
//审判程序接口
NSString *const GetSpcxInfoUrl = @"m/getSpcxInfo.do";
//案件当事人接口
NSString *const DsrUrl = @"m/queryDsr.do";
//删除当事人
NSString *const DelDsrUrl = @"m/delDsr.do";

//保存当事人接口
NSString *const SaveDsrUrl = @"m/saveDsr.do";
//诉讼材料接口
NSString *const SsclUrl = @"m/querySscl.do";
//保存诉讼材料
NSString *const SaveSsclUrl = @"m/saveSscl.do";
//删除讼诉材料
NSString *const DelSsclUrl = @"m/delSscl.do";