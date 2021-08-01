package com.nepxion.discovery.platform.server.controller;

/**
 * <p>Title: Nepxion Discovery</p>
 * <p>Description: Nepxion Discovery</p>
 * <p>Copyright: Copyright (c) 2017-2050</p>
 * <p>Company: Nepxion</p>
 *
 * @author Ning Zhang
 * @version 1.0
 */

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.nepxion.discovery.common.entity.ArithmeticType;
import com.nepxion.discovery.common.entity.RelationalType;
import com.nepxion.discovery.platform.server.entity.base.BaseStateEntity;
import com.nepxion.discovery.platform.server.entity.dto.BlueGreenDto;
import com.nepxion.discovery.platform.server.service.BlueGreenService;
import com.nepxion.discovery.platform.server.service.RouteArrangeService;

@Controller
@RequestMapping(BlueGreenController.PREFIX)
public class BlueGreenPageController {
    @Autowired
    private BlueGreenService blueGreenService;
    @Autowired
    private RouteArrangeService routeArrangeService;

    @GetMapping("list")
    public String list() {
        return String.format("%s/%s", BlueGreenController.PREFIX, "list");
    }

    @GetMapping("add")
    public String add(Model model) throws Exception {
        BlueGreenDto blueGreenDto = new BlueGreenDto();
        model.addAttribute("operators", ArithmeticType.values());
        model.addAttribute("logics", RelationalType.values());
        model.addAttribute("entity", blueGreenDto);
        return String.format("%s/%s", BlueGreenController.PREFIX, "add");
    }

    @GetMapping("edit")
    public String edit(Model model, @RequestParam(name = "id") Long id) {
        BlueGreenDto blueGreenDto = blueGreenService.getById(id);
        model.addAttribute("operators", ArithmeticType.values());
        model.addAttribute("logics", RelationalType.values());
        model.addAttribute("entity", blueGreenDto);
        return String.format("%s/%s", BlueGreenController.PREFIX, "edit");
    }

    @GetMapping("verify")
    public String verify(Model model, @RequestParam(name = "expression") String expression) {
        model.addAttribute("expression", expression);
        return String.format("%s/%s", BlueGreenController.PREFIX, "verify");
    }

    @GetMapping("working")
    public String working(Model model) {
        model.addAttribute("portalTypes", BaseStateEntity.PortalType.values());
        return String.format("%s/%s", BlueGreenController.PREFIX, "working");
    }
}