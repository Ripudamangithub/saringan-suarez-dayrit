﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Omnipresence.Mvc2.Models;
using Omnipresence.Processing;
using System.Data;

namespace Omnipresence.Mvc2.Controllers
{
    public class EventController : Controller
    {
        //
        // GET: /Event/

        private AccountServices accountServices;
        private EventServices eventServices;
        
        protected override void Initialize(System.Web.Routing.RequestContext requestContext)
        {
            eventServices = EventServices.GetInstance();
            accountServices = AccountServices.GetInstance();
            base.Initialize(requestContext);
        }
        [Authorize]
        public ActionResult Index(int id = 0)
        {
            EventModel model = eventServices.GetEventById(id);
            if (model == null) return RedirectToAction("Index", "Home");
            return View(model);
        }

        public ActionResult New()
        {
            CreateEventViewModel model = new CreateEventViewModel();
            model.Title = "";
            model.CreateTime = DateTime.Now;
            model.DeleteTime = DateTime.Now;
            model.StartTime = DateTime.Now;
            model.EndTime = DateTime.Now;
            return View(model);
        }

        [HttpPost]
        public ActionResult New(CreateEventViewModel model)
        {
            CreateEventModel cem = new CreateEventModel();
            cem.Address = model.Address;
            cem.CategoryString = model.CategoryString;
            cem.Description = model.Description;
            cem.EndTime = model.EndTime;
            cem.Latitude = model.Latitude;
            cem.Longitude = model.Longitude;
            cem.StartTime = model.StartTime;
            cem.Title = model.Title;
            string username = User.Identity.Name;
            cem.UserProfileId = accountServices.GetUserProfileByUsername(username).UserProfileId;
            try
            {
                eventServices.CreateEvent(cem);
            }
            catch (ConstraintException e)
            {
                ViewData["message"] = e.Message;

                if (e.Data.Contains("Entity"))
                {
                    ViewData["message"] = e.Data["Entity"] + " cannot be left blank!";
                }

                return View(model);
            }
            return Redirect("/");
        }

        public ActionResult Edit(int id)
        {
            EventModel em = eventServices.GetEventById(id);

            return View(em);
        }

    }
    
}
