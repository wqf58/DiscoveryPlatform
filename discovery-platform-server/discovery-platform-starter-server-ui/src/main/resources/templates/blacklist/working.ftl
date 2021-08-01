<@compress single_line=true>
    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
        <#include "../common/layui.ftl">
    </head>
    <body>

    <div class="layui-fluid">
        <div class="layui-card">
            <div class="layui-form layui-card-header layuiadmin-card-header-auto">
                <div class="layui-form-item">
                    <div class="layui-inline">网关列表</div>
                    <div class="layui-inline" style="width:350px">
                        <select id="gatewayName" name="gatewayName" lay-filter="gatewayName" autocomplete="off"
                                lay-verify="required" class="layui-select" lay-search>
                            <option value="">请选择网关名称</option>
                            <#list gatewayNames as gatewayName>
                                <option value="${gatewayName}">${gatewayName}</option>
                            </#list>
                        </select>
                    </div>


                    <div class="layui-inline" style="width:120px">
                        <button id="btnRefreshGateway" class="layui-btn">
                            刷新网关列表
                        </button>
                    </div>

                    <div class="layui-inline"></div>
                    <div id="tip" class="layui-inline" style="width:350px">
                    </div>

                </div>
            </div>

            <div class="layui-card-body">
                <div lay-filter="tab" class="layui-tab layui-tab-brief">
                    <ul id="tabTitle" class="layui-tab-title">
                    </ul>
                    <div id="tabContent" class="layui-tab-content" style="height: 430px">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        layui.config({base: '../../..${ctx}/layuiadmin/'}).extend({index: 'lib/index'}).use(['index', 'table'], function () {
            const table = layui.table, form = layui.form, $ = layui.$, admin = layui.admin, element = layui.element;
            let chooseGatewayName = '', tabIndex = -1;
            tableErrorHandler();

            element.on('tab(tab)', function (obj) {
                tabIndex = obj.index;
            });

            table.on('toolbar(grid)', function (obj) {
                if (obj.event === 'refresh') {
                    reloadGrid();
                }
            });

            form.on('select(gatewayName)', function (data) {
                chooseGatewayName = data.value;
                reloadGrid();
            });

            $("#btnRefreshGateway").click(function () {
                const gatewayNames = admin.getGatewayName();
                const selGatewayName = $("select[name=gatewayName]");
                selGatewayName.html('<option value="">请选择网关名称</option>');
                $.each(gatewayNames, function (key, val) {
                    let option;
                    if (chooseGatewayName == val) {
                        option = $("<option>").attr('selected', 'selected').val(val).text(val);
                        chooseGatewayName = val;
                    } else {
                        option = $("<option>").val(val).text(val);
                    }
                    selGatewayName.append(option);
                });
                layui.form.render('select');
                reloadGrid();
            });

            function reloadGrid() {
                $("#tabTitle").html('');
                $("#tabContent").html('');
                if (chooseGatewayName != null && chooseGatewayName != '') {
                    admin.post("do-list-working", {"gatewayName": chooseGatewayName}, function (result) {
                        const data = result.data, set = new Set();
                        let index = 0;
                        $.each(data, function (k, v) {
                            set.add(JSON.stringify(v));
                            const tabTitle = k;
                            const tabId = 'tab_' + index;
                            const gridId = 'grid_' + index;
                            let showTitle = '', showContent = '';
                            if (tabIndex < 0) {
                                tabIndex = 0;
                            }
                            if (index == tabIndex) {
                                showTitle = 'class="layui-this"';
                                showContent = 'layui-show';
                            }

                            $("#tabTitle").append('<li id="' + tabId + '" ' + showTitle + '>' + tabTitle + '</li>');
                            $("#tabContent").append('<div class="layui-tab-item ' + showContent + '"><table id="' + gridId + '" lay-filter="grid"></table></div>');
                            index++;

                            element.render();
                            table.render({
                                elem: '#' + gridId,
                                cellMinWidth: 80,
                                page: false,
                                limit: 99999999,
                                limits: [99999999],
                                even: true,
                                loading: false,
                                text: {
                                    none: '暂无相关数据'
                                },
                                cols: [[
                                    {type: 'numbers', title: '序号', width: 50},
                                    {field: 'gatewayName', title: '网关名称', width: 350},
                                    {field: 'serviceName', title: '服务名称', width: 300},
                                    {
                                        field: 'serviceBlacklistType', title: '黑名单类型', width: 230, templet: function (d) {
                                            if (d.serviceBlacklistType == 1) {
                                                return "UUID";
                                            } else {
                                                return "IP地址和端口";
                                            }
                                            return d.serviceBlacklistType;
                                        }
                                    },
                                    {field: 'serviceBlacklist', title: '黑名单'}
                                ]],
                                data: v
                            });
                        });
                        element.render();

                        if (set.size <= 1) {
                            $("#tip").html('<span class="layui-badge layui-bg-blue"><h3><b>一致性检查</b>:&nbsp;&nbsp;所有网关的黑名单信息一致&nbsp;</h3></span>');
                        } else {
                            $("#tip").html('<span class="layui-badge layui-bg-orange"><h3><b>一致性检查</b>:&nbsp;&nbsp;有网关的黑名单信息不一致, 请检查&nbsp;</h3></span>');
                        }
                    });
                } else {
                    element.render();
                    table.reload('grid', {'data': []});
                }
            }

            <#if (gatewayNames?size==1) >
            chooseSelectOption('gatewayName', 1);
            </#if>
        });
    </script>
    </body>
    </html>
</@compress>