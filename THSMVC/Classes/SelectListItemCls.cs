using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Models;

namespace THSMVC.App_Code
{
    public static class SelectListItemCls
    {
        public static IEnumerable<SelectListItem> ToSelectListItemsInstance(IEnumerable<Instance> albums, int? selectedId)
        {
            return
                albums.OrderBy(album => album.Name)
                      .Select(album =>
                          new SelectListItem
                          {
                              Selected = (album.Id == selectedId),
                              Text = album.Name,
                              Value = album.Id.ToString()
                          });
        }

       
        internal static IEnumerable<SelectListItem> ToSelectListItemsRole(IEnumerable<Role> albums, int selectedId)
        {
            return
             albums.OrderBy(album => album.Role1)
                   .Select(album =>
                       new SelectListItem
                       {
                           Selected = (album.Id == selectedId),
                           Text = album.Role1,
                           Value = album.Id.ToString()
                       });
        }

        internal static IEnumerable<SelectListItem> ToSelectListItemsMenu(IEnumerable<Menu> albums, int selectedId)
        {
            return
       albums.OrderBy(album => album.Id)
             .Select(album =>
                 new SelectListItem
                 {
                     Selected = (album.Id == selectedId),
                     Text = album.Name,
                     Value = album.Id.ToString()
                 });
        }

        internal static IEnumerable<SelectListItem> ToSelectListItemsGroup(IEnumerable<MenuGroup> albums, int selectedId)
        {
            return
      albums.OrderBy(album => album.Id)
            .Select(album =>
                new SelectListItem
                {
                    Selected = (album.Id == selectedId),
                    Text = album.GroupName,
                    Value = album.Id.ToString()
                });
        }


        internal static IEnumerable<SelectListItem> ToSelectListItemsGoldRates(IEnumerable<GoldRate> albums, int selected)
        {
            return
      albums.OrderBy(album => album.Id)
            .Select(album =>
                new SelectListItem
                {
                    Selected = (album.Id == selected),
                    Text = album.GoldCity,
                    Value = album.URL
                });
        }
    }
}