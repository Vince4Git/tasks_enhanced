###

ownCloud - Tasks

@author Raimund Schlüßler
@copyright 2013

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
License as published by the Free Software Foundation; either
version 3 of the License, or any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU AFFERO GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU Affero General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

###

angular.module('Tasks').factory 'ListsModel',
['TasksModel', '_Model', '_EqualQuery', 'Utils',
(TasksModel, _Model, _EqualQuery, Utils) ->
	class ListsModel extends _Model

		constructor: (@_$tasksmodel, @_utils) ->
			@_tmpIdCache = {}
			super()

		add: (list, clearCache=true) ->

			tmplist = @_tmpIdCache[list.tmpID]

			updateById = angular.isDefined(list.id) and
			angular.isDefined(@getById(list.id))

			updateByTmpId = angular.isDefined(tmplist) and
			angular.isUndefined(tmplist.id)

			if updateById or updateByTmpId
				@update(list, clearCache)
			else
				if angular.isDefined(list.id)
					super(list, clearCache)
				else
					@_tmpIdCache[list.tmpID] = list
					@_data.push(list)
					if clearCache
						@_invalidateCache()

		update: (list, clearCache=true) ->
			tmplist = @_tmpIdCache[list.tmpID]

			if angular.isDefined(list.id) and
			angular.isDefined(tmplist) and
			angular.isUndefined(tmplist.id)
				tmplist.id = list.id
				@_dataMap[list.id] = tmplist
			
			list.void = false
			super(list, clearCache)

		removeById: (listID) ->
			super(listID)

		voidAll: () ->
			lists = @getAll()
			for list in lists
				list.void = true

		removeVoid: () ->
			lists = @getAll()
			listIDs = []
			for list in lists
				if list.void
					listIDs.push list.id
			for id in listIDs
				@removeById(id)

		getStandardList: () ->
			if @size()
				lists = @getAll()
				return lists[0].id

		checkName: (listName, listID=undefined) ->
			lists = @getAll()
			ret = true
			for list in lists
				if list.displayname == listName &&
				listID != list.id
					ret = false
			return ret

		getCount: (listID,type) ->
			count = 0
			tasks = @_$tasksmodel.getAll()
			switch type
				when 'all'
					for task in tasks
						count += (task.calendarid==listID && !task.completed)
					return count
				when 'current'
					for task in tasks
						count += (task.calendarid==listID && !task.completed &&
							@_$tasksmodel.current(task.start))
					return count
				when 'completed'
					for task in tasks
						count += (task.calendarid==listID && task.completed)
					return count
				when 'starred'
					for task in tasks
						count += (task.calendarid==listID && !task.completed && task.starred)
					return count
				when 'today'
					for task in tasks
						count += (task.calendarid==listID && !task.completed &&
							@_$tasksmodel.today(task.due))
					return count

	return new ListsModel(TasksModel, Utils)
]