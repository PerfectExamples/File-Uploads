//
//  Handlers.swift
//  Perfect-App-Template
//
//  Created by Jonathan Guthrie on 2017-02-20.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import StORM
import PerfectLib

class Handlers {


	static func main(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			// Context variable, which also initializes the "files" array
			var context = ["files":[[String:String]]()]

			// Process only if request.postFileUploads is populated
			if let uploads = request.postFileUploads, uploads.count > 0 {

				// iterate through the file uploads.
				for upload in uploads {

					// move file
					let thisFile = File(upload.tmpFileName)
					do {
						let _ = try thisFile.moveTo(path: "./webroot/uploads/\(upload.fileName)", overWrite: true)
					} catch {
						print(error)
					}
				}
			}

			// Inspect the uploads directory contents
			let d = Dir("./webroot/uploads")
			do{
				try d.forEachEntry(closure: {f in
					context["files"]?.append(["name":f])
				})
			} catch {
				print(error)
			}

			// Render the Mustache template, with context.
			response.render(template: "templates/index", context: context)
			response.completed()
		}
	}

}
